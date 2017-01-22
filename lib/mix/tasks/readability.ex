defmodule Mix.Tasks.Readability do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Query, only: [from: 2]
  require Readability

  def run(_args) do
    ensure_started(SenorPink.Repo, [])

    query = from a in "article",
            # limit: 1,
            select: a.id
    arr = SenorPink.Repo.all(query)
    IO.inspect length(arr)
    IO.inspect arr
    loop_article_list(arr)
  end

  def loop_article_list([head | tail]) do
    read_article(head)
    loop_article_list(tail)
  end
  def loop_article_list([]), do: []

  def read_article(id) do
    article = SenorPink.Repo.get!(SenorPink.Article, id)
    try do
      IO.inspect "before normalize"
      html_tree = Readability.Helper.normalize(article.html)
      IO.inspect "before build"
      article_tree = Readability.ArticleBuilder.build(html_tree, [])
      # IO.inspect article_tree
      IO.inspect "before read html"
      article_html = Readability.readable_html(article_tree)
      # IO.inspect article_html
      IO.inspect "before read text"
      article_text = Readability.readable_text(article_tree)
      # IO.inspect article_text
      IO.inspect "before change"
      article = Ecto.Changeset.change article, article_html: article_html, article_text: article_text
      IO.inspect article
      SenorPink.Repo.update(article)
    rescue
      e in RuntimeError -> e
      e in FunctionClauseError -> e
      e -> e
    end

  end
end
