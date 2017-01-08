defmodule Mix.Tasks.Hello do
  use Mix.Task
  alias ElixirCrawler.Base

  def run(_) do
    Mix.shell.info "hello"
    Base.start()
  end
end
