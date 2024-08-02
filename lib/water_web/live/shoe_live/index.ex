defmodule WaterWeb.ShoeLive.Index do
  use WaterWeb, :live_view

  alias Water.Cobbler
  alias Water.Cobbler.Shoe

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :shoes, Cobbler.list_shoes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shoe")
    |> assign(:shoe, Cobbler.get_shoe!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shoe")
    |> assign(:shoe, %Shoe{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shoes")
    |> assign(:shoe, nil)
  end

  @impl true
  def handle_info({WaterWeb.ShoeLive.FormComponent, {:saved, shoe}}, socket) do
    {:noreply, stream_insert(socket, :shoes, shoe)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shoe = Cobbler.get_shoe!(id)
    {:ok, _} = Cobbler.delete_shoe(shoe)

    {:noreply, stream_delete(socket, :shoes, shoe)}
  end
end
