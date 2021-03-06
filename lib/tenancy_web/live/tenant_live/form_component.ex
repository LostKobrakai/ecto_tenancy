defmodule TenancyWeb.TenantLive.FormComponent do
  use TenancyWeb, :live_component

  alias Tenancy.TenantManagement

  @impl true
  def update(%{tenant: tenant} = assigns, socket) do
    changeset = TenantManagement.change_tenant(tenant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tenant" => tenant_params}, socket) do
    changeset =
      socket.assigns.tenant
      |> TenantManagement.change_tenant(tenant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tenant" => tenant_params}, socket) do
    save_tenant(socket, socket.assigns.action, tenant_params)
  end

  defp save_tenant(socket, :edit, tenant_params) do
    case TenantManagement.update_tenant(socket.assigns.tenant, tenant_params) do
      {:ok, _tenant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenant updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tenant(socket, :new, tenant_params) do
    case TenantManagement.create_tenant(tenant_params) do
      {:ok, _tenant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenant created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
