defmodule Sirbiz.Repo do
  use Ecto.Repo,
    otp_app: :sirbiz,
    adapter: Ecto.Adapters.Postgres
end
