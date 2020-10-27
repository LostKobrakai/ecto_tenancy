defmodule Tenancy.Inventory.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :body, :string
    field :name, :string

    field :tenant_id, :integer
    belongs_to :product, Tenancy.Inventory.Product

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:name, :body])
    |> validate_required([:name, :body])
  end

  @doc false
  def set_tenant(product, tenant_id) do
    change(product, tenant_id: tenant_id)
  end

  @doc false
  def set_product(product, product_id) do
    change(product, product_id: product_id)
  end
end
