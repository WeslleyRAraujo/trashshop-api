defmodule TrashShop.Repo do
  use Ecto.Repo,
    otp_app: :trashshop,
    adapter: Ecto.Adapters.Postgres
end
