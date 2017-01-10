defmodule SenorPink.Scrape do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    start()
    {:ok, {%{}}}
  end

  def start do
    {:ok, data} = SenorPink.Repo.insert %SenorPink.Article{title: "Ahab", url: "http:www.baidu.com", issue: 87}
  end
end
