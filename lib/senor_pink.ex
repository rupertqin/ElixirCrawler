defmodule SenorPink do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Friends.Worker.start_link(arg1, arg2, arg3)
      supervisor(SenorPink.Repo, []),
      worker(SenorPink.Scrape, []),
      # worker(Task, [SenorPink.Scrape, :start, []]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SenorPink.Supervisor]
    Supervisor.start_link(children, opts)

  end

end
