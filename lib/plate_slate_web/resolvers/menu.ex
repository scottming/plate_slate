defmodule PlateSlateWeb.Resolvers.Menu do
  import Absinthe.Resolution.Helpers, only: [batch: 3]
  import AbsintheErrorPayload.Payload
  alias AbsintheErrorPayload.ValidationMessage
  alias PlateSlate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end

  def items_for_category(category, _, _) do
    query = Ecto.assoc(category, :items)
    {:ok, PlateSlate.Repo.all(query)}
  end

  def category_for_item(menu_item, _, _) do
    batch({PlateSlate.Menu, :categories_by_id}, menu_item.category_id, fn
      categories ->
        {:ok, Map.get(categories, menu_item.category_id)}
    end)
  end

  def create_item(_, %{input: params}, _) do
    with {:ok, item} <- Menu.create_item(params) do
      # {:ok, %{menu_item: item}}
      {:ok, item}
    else
      _ -> {:error, "test error"}
    end
  end

  def create_item_manual(_, %{input: params}, _) do
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, success_payload(item)}
    else
      _ ->
        {:ok, error_payload(%ValidationMessage{code: "test", message: "test error"})}
    end
  end
end
