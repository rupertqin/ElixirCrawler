defmodule SenorPink.Scrape do
  use GenServer

  @issues     Enum.to_list(145..150)
  # @issue.._   @issues
  @per_page   4
  @base_url   "http://weekly.manong.io/issues/"
  @headers    ["User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3"]
  @request_options    [recv_timeout: 5000, follow_redirect: true, max_redirect: 5]

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    start()
    {:ok, {%{}}}
  end

  def start do
    loop_issue_list(@issues)
  end

  def loop_issue_list([head | tail]) do
    fetch_issue(head)
    loop_issue_list(tail)
  end

  def loop_issue_list([]), do: []

  def fetch_issue(issue) do
    HTTPoison.start
    {:ok, response} = HTTPoison.get("#{@base_url}#{issue}", @headers, @request_options)
    case response.status_code do
      200 ->
        links = extract_valid_a(response.body)
        loop_article_list(links, issue)
      _ ->
        IO.inspect "BAD LINK: "
    end
    []
  end

  def loop_article_list([head | tail], issue) do
    fetch_article(head, issue)
    loop_article_list(tail, issue)
  end

  def loop_article_list([], issue), do: []

  def fetch_article({href, title}, issue) do
    HTTPoison.start
    {:ok, response} = HTTPoison.get(href, @headers, @request_options)
    case response.status_code do
      200 ->
        # Enum.at(response.headers, 3)
        {:ok, data} = SenorPink.Repo.insert %SenorPink.Article{title: title, url: href, issue: issue, html: response.body}
      _ ->
        IO.inspect "BAD LINK: "
    end

  end

  def extract_valid_a(html) do
    Floki.find(html, "h4 a[href^='http://weekly.manong.io/bounce']")
    |> Enum.map(fn(a) ->
      {"a", [_, {"href", href}], [title]} = a
      href = extract_real_url(href)
      IO.inspect href
      {href, title}
    end)
    |> Enum.filter(fn {href, _} -> !(href =~ ~r/job.manong.io/) end)
    |> Enum.slice(0, 4)
  end

  def extract_real_url(url) do
    URI.parse(url)
    |>Map.get(:query)
    |>URI.decode_query
    |>Map.get("url")
  end
end
