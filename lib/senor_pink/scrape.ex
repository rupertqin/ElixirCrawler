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
    IO.inspect head
    fetch_issue(head)
    loop_issue_list(tail)
  end

  def loop_issue_list([]) do
    []
  end

  def fetch_issue(issue) do
    HTTPoison.start
    {:ok, response} = HTTPoison.get("#{@base_url}#{issue}", @headers, @request_options)
    IO.inspect response
    case response.status_code do
      200 ->
        h4 = Floki.find(response.body, "h4")
             |> Enum.slice(0,4)
        IO.inspect h4
        loop_article_list(h4)
      _ ->
        IO.inspect "BAD LINK: "
    end
    []
  end

  def loop_article_list([head | tail]) do
    fetch_article(head)
    loop_article_list(tail)
  end

  def loop_article_list([]) do
    []
  end

  def fetch_article(el) do
    HTTPoison.start
    IO.inspect el
    {"h4", [], [{"a", [{"target", _}, {"href", href}], _} | _]} = el
    IO.inspect href
    {:ok, response} = HTTPoison.get(href, @headers, @request_options)
    case response.status_code do
      200 ->
        {:ok, data} = SenorPink.Repo.insert %SenorPink.Article{title: "Ahab", url: "http:www.baidu.com", issue: 87, html: response.body}
      _ ->
        IO.inspect "BAD LINK: "
    end

  end
end
