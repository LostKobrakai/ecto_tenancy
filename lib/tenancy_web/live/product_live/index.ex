defmodule TenancyWeb.ProductLive.Index do
  use TenancyWeb, :live_view

  alias Tenancy.Inventory
  alias Tenancy.Inventory.Product

  @impl true
  def mount(_params, %{"tenant_id" => id}, socket) do
    Tenancy.Repo.put_tenant_id(id)
    {:ok, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Inventory.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Inventory.get_product!(id)
    {:ok, _} = Inventory.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Inventory.list_products()
  end
end
