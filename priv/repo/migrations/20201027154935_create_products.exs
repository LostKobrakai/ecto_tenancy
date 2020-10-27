defmodule Tenancy.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :tenant_id, references(:tenants, column: :tenant_id), null: false

      timestamps()
    end

    create unique_index(:products, [:id, :tenant_id])
  end
end
