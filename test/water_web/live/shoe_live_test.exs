defmodule WaterWeb.ShoeLiveTest do
  use WaterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Water.CobblerFixtures

  @create_attrs %{size: 42, color: "some color", brand: "some brand", style: "some style"}
  @update_attrs %{size: 43, color: "some updated color", brand: "some updated brand", style: "some updated style"}
  @invalid_attrs %{size: nil, color: nil, brand: nil, style: nil}

  defp create_shoe(_) do
    shoe = shoe_fixture()
    %{shoe: shoe}
  end

  describe "Index" do
    setup [:create_shoe]

    test "lists all shoes", %{conn: conn, shoe: shoe} do
      {:ok, _index_live, html} = live(conn, ~p"/shoes")

      assert html =~ "Listing Shoes"
      assert html =~ shoe.color
    end

    test "saves new shoe", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/shoes")

      assert index_live |> element("a", "New Shoe") |> render_click() =~
               "New Shoe"

      assert_patch(index_live, ~p"/shoes/new")

      assert index_live
             |> form("#shoe-form", shoe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#shoe-form", shoe: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/shoes")

      html = render(index_live)
      assert html =~ "Shoe created successfully"
      assert html =~ "some color"
    end

    test "updates shoe in listing", %{conn: conn, shoe: shoe} do
      {:ok, index_live, _html} = live(conn, ~p"/shoes")

      assert index_live |> element("#shoes-#{shoe.id} a", "Edit") |> render_click() =~
               "Edit Shoe"

      assert_patch(index_live, ~p"/shoes/#{shoe}/edit")

      assert index_live
             |> form("#shoe-form", shoe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#shoe-form", shoe: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/shoes")

      html = render(index_live)
      assert html =~ "Shoe updated successfully"
      assert html =~ "some updated color"
    end

    test "deletes shoe in listing", %{conn: conn, shoe: shoe} do
      {:ok, index_live, _html} = live(conn, ~p"/shoes")

      assert index_live |> element("#shoes-#{shoe.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shoes-#{shoe.id}")
    end
  end

  describe "Show" do
    setup [:create_shoe]

    test "displays shoe", %{conn: conn, shoe: shoe} do
      {:ok, _show_live, html} = live(conn, ~p"/shoes/#{shoe}")

      assert html =~ "Show Shoe"
      assert html =~ shoe.color
    end

    test "updates shoe within modal", %{conn: conn, shoe: shoe} do
      {:ok, show_live, _html} = live(conn, ~p"/shoes/#{shoe}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shoe"

      assert_patch(show_live, ~p"/shoes/#{shoe}/show/edit")

      assert show_live
             |> form("#shoe-form", shoe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#shoe-form", shoe: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/shoes/#{shoe}")

      html = render(show_live)
      assert html =~ "Shoe updated successfully"
      assert html =~ "some updated color"
    end
  end
end
