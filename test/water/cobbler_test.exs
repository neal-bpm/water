defmodule Water.CobblerTest do
  use Water.DataCase

  alias Water.Cobbler

  describe "shoes" do
    alias Water.Cobbler.Shoe

    import Water.CobblerFixtures

    @invalid_attrs %{size: nil, color: nil, brand: nil, style: nil}

    test "list_shoes/0 returns all shoes" do
      shoe = shoe_fixture()
      assert Cobbler.list_shoes() == [shoe]
    end

    test "get_shoe!/1 returns the shoe with given id" do
      shoe = shoe_fixture()
      assert Cobbler.get_shoe!(shoe.id) == shoe
    end

    test "create_shoe/1 with valid data creates a shoe" do
      valid_attrs = %{size: 42, color: "some color", brand: "some brand", style: "some style"}

      assert {:ok, %Shoe{} = shoe} = Cobbler.create_shoe(valid_attrs)
      assert shoe.size == 42
      assert shoe.color == "some color"
      assert shoe.brand == "some brand"
      assert shoe.style == "some style"
    end

    test "create_shoe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cobbler.create_shoe(@invalid_attrs)
    end

    test "update_shoe/2 with valid data updates the shoe" do
      shoe = shoe_fixture()
      update_attrs = %{size: 43, color: "some updated color", brand: "some updated brand", style: "some updated style"}

      assert {:ok, %Shoe{} = shoe} = Cobbler.update_shoe(shoe, update_attrs)
      assert shoe.size == 43
      assert shoe.color == "some updated color"
      assert shoe.brand == "some updated brand"
      assert shoe.style == "some updated style"
    end

    test "update_shoe/2 with invalid data returns error changeset" do
      shoe = shoe_fixture()
      assert {:error, %Ecto.Changeset{}} = Cobbler.update_shoe(shoe, @invalid_attrs)
      assert shoe == Cobbler.get_shoe!(shoe.id)
    end

    test "delete_shoe/1 deletes the shoe" do
      shoe = shoe_fixture()
      assert {:ok, %Shoe{}} = Cobbler.delete_shoe(shoe)
      assert_raise Ecto.NoResultsError, fn -> Cobbler.get_shoe!(shoe.id) end
    end

    test "change_shoe/1 returns a shoe changeset" do
      shoe = shoe_fixture()
      assert %Ecto.Changeset{} = Cobbler.change_shoe(shoe)
    end
  end
end
