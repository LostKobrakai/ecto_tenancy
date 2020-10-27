defmodule Tenancy.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :tenant_id, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def set_tenant(product, tenant_id) do
    change(product, tenant_id: tenant_id)
  end
end
