defmodule Mix.Tasks.Hello do
  use Mix.Task
  alias SenorPink.Base

  def run(_) do
    Mix.shell.info "hello"
    Base.start()
  end
end
