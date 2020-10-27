defmodule Tenancy.Repo do
  use Ecto.Repo,
    otp_app: :tenancy,
    adapter: Ecto.Adapters.Postgres
end
