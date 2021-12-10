# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :trashshop,
  namespace: TrashShop,
  ecto_repos: [TrashShop.Repo]

# Configures the endpoint
config :trashshop, TrashShopWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TrashShopWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TrashShop.PubSub,
  live_view: [signing_salt: "Zu3tiY+I"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :trashshop, TrashShop.Guardian,
  issuer: "TrashShopId",
  secret_key: "IDwHw3dBmb7KAjRLsRvJHdbJ6VTu6yCa8KQv8EeUXOFBl6+p24euVp4Bd9SDsVDm"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
