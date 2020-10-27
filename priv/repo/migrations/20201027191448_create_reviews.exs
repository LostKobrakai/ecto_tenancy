defmodule Tenancy.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :name, :string
      add :body, :string

      add :tenant_id, :integer, null: false
      add :product_id, references(:products, with: [tenant_id: :tenant_id], match: :full), null: false

      timestamps()
    end
  end
end
