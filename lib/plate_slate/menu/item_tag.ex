defmodule PlateSlate.Menu.ItemTag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "item_tags" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
  end
end
