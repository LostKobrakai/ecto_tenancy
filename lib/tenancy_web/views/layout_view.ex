defmodule TenancyWeb.LayoutView do
  use TenancyWeb, :view

  def tenant_select(tenant_id) do
    tenants = Tenancy.TenantManagement.list_tenants()

    options = for tenant <- tenants, do: {tenant.name, tenant.tenant_id}

    js = """
    this.options[this.selectedIndex].value && \
    (window.location.search = '?tenant=' + this.options[this.selectedIndex].value);
    """

    select(:tenants, :id, options, onchange: js, selected: tenant_id)
  end
end
