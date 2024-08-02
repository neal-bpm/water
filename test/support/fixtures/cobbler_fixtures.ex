defmodule Water.CobblerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Water.Cobbler` context.
  """

  @doc """
  Generate a shoe.
  """
  def shoe_fixture(attrs \\ %{}) do
    {:ok, shoe} =
      attrs
      |> Enum.into(%{
        brand: "some brand",
        color: "some color",
        size: 42,
        style: "some style"
      })
      |> Water.Cobbler.create_shoe()

    shoe
  end
end
