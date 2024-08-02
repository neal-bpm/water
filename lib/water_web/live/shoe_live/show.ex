defmodule WaterWeb.ShoeLive.Show do
  use WaterWeb, :live_view

  alias Water.Cobbler

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shoe, Cobbler.get_shoe!(id))}
  end

  defp page_title(:show), do: "Show Shoe"
  defp page_title(:edit), do: "Edit Shoe"
end
