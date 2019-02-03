defmodule PlateSlate.Menu do
  @moduledoc """
  The Menu context.
  """

  import Ecto.Query, warn: false
  alias PlateSlate.Repo

  alias PlateSlate.Menu.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  alias PlateSlate.Menu.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """

  def list_items(filters) do
    filters
    |> Enum.reduce(Item, fn
      {_, nil}, query ->
        query

      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:matching, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")
    end)
    |> Repo.all()
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  alias PlateSlate.Menu.ItemTag

  @doc """
  Returns the list of item_tags.

  ## Examples

      iex> list_item_tags()
      [%ItemTag{}, ...]

  """
  def list_item_tags do
    Repo.all(ItemTag)
  end

  @doc """
  Gets a single item_tag.

  Raises `Ecto.NoResultsError` if the Item tag does not exist.

  ## Examples

      iex> get_item_tag!(123)
      %ItemTag{}

      iex> get_item_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_tag!(id), do: Repo.get!(ItemTag, id)

  @doc """
  Creates a item_tag.

  ## Examples

      iex> create_item_tag(%{field: value})
      {:ok, %ItemTag{}}

      iex> create_item_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_tag(attrs \\ %{}) do
    %ItemTag{}
    |> ItemTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_tag.

  ## Examples

      iex> update_item_tag(item_tag, %{field: new_value})
      {:ok, %ItemTag{}}

      iex> update_item_tag(item_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_tag(%ItemTag{} = item_tag, attrs) do
    item_tag
    |> ItemTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ItemTag.

  ## Examples

      iex> delete_item_tag(item_tag)
      {:ok, %ItemTag{}}

      iex> delete_item_tag(item_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_tag(%ItemTag{} = item_tag) do
    Repo.delete(item_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_tag changes.

  ## Examples

      iex> change_item_tag(item_tag)
      %Ecto.Changeset{source: %ItemTag{}}

  """
  def change_item_tag(%ItemTag{} = item_tag) do
    ItemTag.changeset(item_tag, %{})
  end
end
