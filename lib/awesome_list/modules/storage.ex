defmodule AwesomeList.Storage do
  alias AwesomeList.{Repo, Awesome}
  require Logger
  import Ecto.Query

  def get_list(stars \\ 0) do
    Awesome.Category
    |> join(:left, [cat], repo in assoc(cat, :repos))
    |> where([cat, repo], repo.stars >= ^stars)
    |> order_by([cat, repo], asc: cat.title, asc: repo.title)
    |> preload([cat, repo], repos: repo)
    |> Repo.all()
  end

  def save_list(list) do
    saved_list =
      list
      |> Enum.map(&save_category/1)
      |> List.flatten()
      |> Enum.map(&save_awesome_repos/1)

    {:ok, saved_list}
  end

  defp save_category({title, description, repos}) do
    category = %Awesome.Category{title: title, description: description}

    {:ok, inserted} =
      Repo.insert(
        category,
        on_conflict: {:replace, [:title, :description]},
        conflict_target: :title
      )

    repos
    |> Enum.map(fn r -> Map.put(r, :category, inserted) end)
  end

  defp save_awesome_repos(%{
         category: category,
         name: title,
         description: description,
         repo: %{last_updated: last_updated, stars: stars},
         url: url
       }) do
    awesome_item = %Awesome.Item{
      title: title,
      description: description,
      last_updated: last_updated |> NaiveDateTime.from_iso8601!(),
      stars: stars,
      url: url,
      category: category
    }

    {:ok, inserted} =
      Repo.insert(
        awesome_item,
        on_conflict: {:replace, [:title, :stars, :last_updated, :description, :category_id]},
        conflict_target: :url
      )

    inserted
  end

  defp save_awesome_repos(_) do
    nil
  end
end
