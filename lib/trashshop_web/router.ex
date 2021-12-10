defmodule TrashShopWeb.Router do
  use TrashShopWeb, :router
  
  import TrashShopWeb.Authentication

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
    plug :authenticate
  end

  scope "/", TrashShopWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", TrashShopWeb do
    post "/login", LoginController, :create
    # post "/create_user", UserController, :create
  end

  scope "/api/v1", TrashShopWeb do
    pipe_through :api
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrashShopWeb do
  #   pipe_through :api
  # end
end
