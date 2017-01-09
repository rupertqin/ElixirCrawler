defmodule ElixirCrawler.Article do
  use Ecto.Schema

  schema "article" do
    field :title, :string
    field :url,   :string
    field :issue, :integer
    field :ps,    :string
    field :html,  :string

    timestamps
  end

  # @required_fields ~w(title url issue)
  # @optional_fields ~w()

  # def changeset(article, params \\ %{}) do
  #   article
  #   |> Ecto.Changeset.cast(params, ~w(title url issue))
  #   |> Ecto.Changeset.validate_required([:title, :url])
  # end
end
