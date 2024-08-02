defmodule WaterWeb.ShoeLive.FormComponent do
  use WaterWeb, :live_component

  alias Water.Cobbler

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage shoe records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="shoe-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:brand]} type="text" label="Brand" />
        <.input field={@form[:size]} type="number" label="Size" />
        <.input field={@form[:color]} type="text" label="Color" />
        <.input field={@form[:style]} type="text" label="Style" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Shoe</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{shoe: shoe} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Cobbler.change_shoe(shoe))
     end)}
  end

  @impl true
  def handle_event("validate", %{"shoe" => shoe_params}, socket) do
    changeset = Cobbler.change_shoe(socket.assigns.shoe, shoe_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"shoe" => shoe_params}, socket) do
    save_shoe(socket, socket.assigns.action, shoe_params)
  end

  defp save_shoe(socket, :edit, shoe_params) do
    case Cobbler.update_shoe(socket.assigns.shoe, shoe_params) do
      {:ok, shoe} ->
        notify_parent({:saved, shoe})

        {:noreply,
         socket
         |> put_flash(:info, "Shoe updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_shoe(socket, :new, shoe_params) do
    case Cobbler.create_shoe(shoe_params) do
      {:ok, shoe} ->
        notify_parent({:saved, shoe})

        {:noreply,
         socket
         |> put_flash(:info, "Shoe created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
