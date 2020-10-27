defmodule TenancyWeb.TenantLive.Index do
  use TenancyWeb, :live_view

  alias Tenancy.TenantManagement
  alias Tenancy.TenantManagement.Tenant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tenants, list_tenants())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tenant")
    |> assign(:tenant, TenantManagement.get_tenant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tenant")
    |> assign(:tenant, %Tenant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tenants")
    |> assign(:tenant, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tenant = TenantManagement.get_tenant!(id)
    {:ok, _} = TenantManagement.delete_tenant(tenant)

    {:noreply, assign(socket, :tenants, list_tenants())}
  end

  defp list_tenants do
    TenantManagement.list_tenants()
  end
end
