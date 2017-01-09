defmodule ElixirCrawler do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Friends.Worker.start_link(arg1, arg2, arg3)
      # worker(Friends.Worker, [arg1, arg2, arg3]),
      supervisor(ElixirCrawler.Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirCrawler.Supervisor]
    ret = Supervisor.start_link(children, opts)
    data = ElixirCrawler.Repo.insert %ElixirCrawler.Article{title: "Ahab", url: "http:www.baidu.com", issue: 87}
    IO.inspect data

    # people = [
    #   %Friends.Person{first_name: "Ryan", last_name: "Bigg", age: 28},
    #   %Friends.Person{first_name: "John", last_name: "Smith", age: 27},
    #   %Friends.Person{first_name: "Jane", last_name: "Smith", age: 26},
    # ]
    # Enum.each(people, fn (person) -> Friends.Repo.insert(person) end)

    ret

  end

end
