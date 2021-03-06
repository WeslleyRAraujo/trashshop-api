defmodule TrashShopWeb.Router do
  use TrashShopWeb, :router
  use Plug.ErrorHandler

  alias TrashShopWeb.HTTPErrors
  alias ThingWeb.RateLimiter

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
    plug TrashShopWeb.Plugs.Authentication
    # plug RateLimiter
  end

  pipeline :api_administration do
    plug TrashShopWeb.Plugs.Administration
    # plug RateLimiter
  end

  # scope "/", TrashShopWeb do
  #   pipe_through :browser

  #   get "/", PageController, :index
  # end

  scope "/api/v1", TrashShopWeb do
    post "/login", LoginController, :create
    post "/create_user", UserController, :create
  end

  scope "/api/v1", TrashShopWeb do
    pipe_through :api

    get "/user_info/:id", UserController, :info
  end

  scope "/api/v1/product", TrashShopWeb do
    pipe_through :api

    post "/", ProductController, :create
    get "/", ProductController, :show
    get "/:code", ProductController, :show_by_id
    get "/user/:user_id", ProductController, :show_by_user
    delete "/:code", ProductController, :delete
  end

  scope "/api/v1/administration", TrashShopWeb do
    pipe_through :api_administration

    get "/all_users", UserController, :show
    delete "/user/:id", UserController, :delete
    get "/all_products", ProductController, :show_all_products
  end

  def handle_errors(conn, _details) do
    case conn.status do
      500 ->
        HTTPErrors.internal_error(conn)

      404 ->
        HTTPErrors.not_found(conn)
    end
  end
end
