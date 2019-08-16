defmodule SenorPink.Article do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "articles" do
    field :title,         :string
    field :url,           :string
    field :issue,         :integer
    field :ps,            :string
    field :html,          :string
    field :article_html,  :string
    field :article_text,  :string

    timestamps()
  end

  # @required_fields ~w(title url issue)
  # @optional_fields ~w()

  # def changeset(article, params \\ %{}) do
  #   article
  #   |> cast(params, ~w(html ps title url issue)a)
  #   |> validate_required([:title, :url])
  # end
end
