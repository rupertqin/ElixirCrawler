defmodule SenorPink.Scrape do
  use GenServer

  @issues     145..150
  # @issue.._   @issues
  @per_page   4
  @base_url   "http://weekly.manong.io/issues/"
  @headers    ["User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3"]
  @options    [recv_timeout: 5000]

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    start()
    {:ok, {%{}}}
  end

  def start do
    HTTPoison.start
    {:ok, response} = HTTPoison.get("http://ginobefunny.com/post/reading_record_201612/", @headers, @options)
    {:ok, data} = SenorPink.Repo.insert %SenorPink.Article{title: "Ahab", url: "http:www.baidu.com", issue: 87, html: response.body}
  end
end
