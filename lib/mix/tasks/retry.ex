defmodule Mix.Tasks.Retry do
  use Mix.Task
  # use Application
  import Mix.Ecto

  @headers    ["User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3"]
  @request_options    [recv_timeout: 10_000, follow_redirect: false, max_redirect: 5, hackney: [:insecure]]

  def run(_args) do
    IO.inspect "task::::::::::"
    ensure_started(SenorPink.Repo, [])

    import Ecto.Query, only: [from: 2]

    query = from a in "article",
            where: a.html == "500",
            select: {a.id, a.title, a.url, a.issue}
    arr = SenorPink.Repo.all(query)
    IO.inspect length(arr)
    IO.inspect arr
    loop_article_list(arr)
  end

  def loop_article_list([head | tail]) do
    fetch_article(head)
    loop_article_list(tail)
  end
  def loop_article_list([]), do: []

  def fetch_article({id, title, href, issue}) do
    HTTPoison.start
    case HTTPoison.get(href, @headers, @request_options) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            # IO.inspect response.body
            article = SenorPink.Repo.get!(SenorPink.Article, id)
            article = Ecto.Changeset.change article, html: response.body
            SenorPink.Repo.update(article)
          n when n in [301, 302, 307]->
          #redirected
          location = response.headers
                     |>Enum.find(fn(t) -> elem(t, 0) == "Location" end)
                     |>elem(1)
          fetch_article({id, location, title, issue})
          _ ->
            "no match"
        end
      {:error, _response} ->
        # SenorPink.Repo.insert_or_update %SenorPink.Article{id: id, title: title, url: href, issue: issue, html: "500"}
        IO.inspect "BAD LINK 500: #{href}"
      _ ->
        # SenorPink.Repo.insert_or_update %SenorPink.Article{id: id, title: title, url: href, issue: issue, html: "400"}
        IO.inspect "BAD LINK 404: #{href}"
    end
  end
end
