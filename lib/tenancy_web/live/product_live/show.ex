defmodule TenancyWeb.ProductLive.Show do
  use TenancyWeb, :live_view

  alias Tenancy.Inventory

  @impl true
  def mount(_params, %{"tenant_id" => id}, socket) do
    Tenancy.Repo.put_tenant_id(id)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Inventory.get_product!(id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
