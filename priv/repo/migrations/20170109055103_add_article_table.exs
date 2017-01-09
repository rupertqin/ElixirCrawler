defmodule ElixirCrawler.Repo.Migrations.AddArticleTable do
  use Ecto.Migration

  def change do
    create table(:article) do
      add :url,       :string, size: 555
      add :title,     :string, size: 255
      add :issue,     :integer
      add :ps,        :string, size: 255
      add :html,      :text

      timestamps()
    end


  end
end
