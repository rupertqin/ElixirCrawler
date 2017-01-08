defmodule ElixirCrawler.Base do
  require HTTPoison
  require Postgrex

  def start do
    # HTTPoison.start
    # {:ok, res} = HTTPoison.get "http://www.baidu.com"
    # IO.inspect res

    {:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "", database: "dev_reading", timeout: 30000);
    Postgrex.query!(pid, "SELECT title FROM articles", [])
  end
end
