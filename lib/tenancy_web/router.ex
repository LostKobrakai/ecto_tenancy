defmodule TenancyWeb.Router do
  use TenancyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TenancyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TenancyWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/tenants", TenantLive.Index, :index
    live "/tenants/new", TenantLive.Index, :new
    live "/tenants/:id/edit", TenantLive.Index, :edit

    live "/tenants/:id", TenantLive.Show, :show
    live "/tenants/:id/show/edit", TenantLive.Show, :edit
  end

  @live_mfa {__MODULE__, :live_session, []}

  scope "/", TenancyWeb do
    pipe_through [:browser, :tenant_id_session]

    live "/products", ProductLive.Index, :index, session: @live_mfa
    live "/products/new", ProductLive.Index, :new, session: @live_mfa
    live "/products/:id/edit", ProductLive.Index, :edit, session: @live_mfa

    live "/products/:id", ProductLive.Show, :show, session: @live_mfa
    live "/products/:id/show/edit", ProductLive.Show, :edit, session: @live_mfa
  end

  # Other scopes may use custom stacks.
  # scope "/api", TenancyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TenancyWeb.Telemetry
    end
  end

  def tenant_id_session(conn, _) do
    tenant_id =
      cond do
        id = conn.query_params["tenant"] -> String.to_integer(id)
        id = get_session(conn, :tenant_id) -> id
        true -> 0
      end

    Tenancy.Repo.put_tenant_id(tenant_id)

    conn
    |> put_session(:tenant_id, tenant_id)
    |> assign(:tenant_id, tenant_id)
  end

  def live_session(_conn) do
    %{"tenant_id" => Tenancy.Repo.get_tenant_id()}
  end
end
