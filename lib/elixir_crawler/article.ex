defmodule ElixirCrawler.Article do
  use Ecto.Schema

  schema "articles" do
    field :title, :string
    field :url, :string
    field :issue, :integer
  end

  def changeset(articles, params \\ %{}) do
    articles
    |> Ecto.Changeset.cast(params, ~w(title url issue))
    |> Ecto.Changeset.validate_required([:title, :url])
  end
end
