defmodule Tenancy.Repo do
  use Ecto.Repo,
    otp_app: :tenancy,
    adapter: Ecto.Adapters.Postgres

  def default_options(_operation) do
    [tenant_id: get_tenant_id()]
  end

  def prepare_query(_operation, query, opts) do
    require Ecto.Query

    cond do
      opts[:skip_tenant_id] || opts[:schema_migration] ->
        {query, opts}

      tenant_id = opts[:tenant_id] ->
        {Ecto.Query.where(query, tenant_id: ^tenant_id), opts}

      true ->
        raise "expected tenant_id or skip_tenant_id to be set"
    end
  end

  @tenant_key {__MODULE__, :tenant_id}

  def put_tenant_id(tenant_id) do
    Process.put(@tenant_key, tenant_id)
  end

  def get_tenant_id() do
    Process.get(@tenant_key)
  end
end
