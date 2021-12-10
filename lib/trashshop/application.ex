defmodule TrashShop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TrashShop.Repo,
      # Start the Telemetry supervisor
      TrashShopWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TrashShop.PubSub},
      # Start the Endpoint (http/https)
      TrashShopWeb.Endpoint
      # Start a worker by calling: TrashShop.Worker.start_link(arg)
      # {TrashShop.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TrashShop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrashShopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
