defmodule PlateSlate.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset


  schema "items" do
    field :added_on, :date
    field :description, :string
    field :name, :string
    field :price, :decimal
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:added_on, :description, :name, :price])
    |> validate_required([:added_on, :description, :name, :price])
  end
end
