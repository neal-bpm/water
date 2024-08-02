defmodule Water.Cobbler.Shoe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shoes" do
    field :size, :integer
    field :color, :string
    field :brand, :string
    field :style, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shoe, attrs) do
    shoe
    |> cast(attrs, [:brand, :size, :color, :style])
    |> validate_required([:brand, :size, :color, :style])
  end
end
