defmodule TrashShopWeb.Router do
  use TrashShopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TrashShopWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug TrashShopWeb.Authentication
  end

  scope "/", TrashShopWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", TrashShopWeb do
    post "/login", LoginController, :create
    post "/create_user", UserController, :create
  end

  scope "/api/v1", TrashShopWeb do
    pipe_through :api

    post "/product", ProductController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrashShopWeb do
  #   pipe_through :api
  # end
end
