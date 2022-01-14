defmodule TrashShopWeb.Plugs.Administration do
  import Plug.Conn
  alias TrashShopWeb.HTTPErrors

  @mocked_user "TRASHMAN"

  @mocked_password "321"

  def init(options), do: options

  def call(conn, _opts), do: authenticate(conn)

  def authenticate(conn) do
    with {:ok, credentials} <- get_auth_header(conn),
         {:ok, user, password} <- get_user_and_password(credentials),
         true <- check_credentials(user, password) do
      conn
    else
      _ -> HTTPErrors.unauthorized(conn, "invalid_credentials")
    end
  end

  def get_auth_header(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> credentials] -> {:ok, credentials}
      [] -> {:error, :token_not_found}
      _ -> {:error, :token_not_found}
    end
  end

  def get_user_and_password(credentials) do
    with {:ok, user_and_password} <- Base.decode64(credentials),
         [user, password] <- String.split(user_and_password, ":") do
      {:ok, user, password}
    else
      _ -> :error
    end
  end

  def check_credentials(user, password) do
    if Mix.env() == :prod do
      System.get_env("ADM_USER") == user and System.get_env("ADM_PASS") == password
    else
      user == @mocked_user and password == @mocked_password
    end
  end
end
