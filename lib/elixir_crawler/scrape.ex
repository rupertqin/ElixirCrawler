defmodule ElixirCrawler.Scrape do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    start()
    {:ok, {%{}}}
  end

  def start do
    {:ok, data} = ElixirCrawler.Repo.insert %ElixirCrawler.Article{title: "Ahab", url: "http:www.baidu.com", issue: 87}
  end
end
