defmodule Water.Repo.Migrations.CreateShoes do
  use Ecto.Migration

  def change do
    create table(:shoes) do
      add :brand, :string
      add :size, :integer
      add :color, :string
      add :style, :string

      timestamps(type: :utc_datetime)
    end
  end
end
