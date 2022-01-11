defmodule TrashShopWeb.Authentication do
  use TrashShopWeb, :controller
  import Plug.Conn
  alias TrashShop.Guardian, as: GuardianModule

  def init(options), do: options

  def call(conn, _opts), do: authenticate(conn)

  def authenticate(conn) do
    with {:ok, token} <- get_token(conn),
         {:ok, claims} <- GuardianModule.decode_and_verify(token),
         {:ok, user} <- GuardianModule.resource_from_claims(claims) do
      assign(conn, :user, user)
    else
      {:error, :token_not_found} -> throw_error(conn)
      _ -> throw_error(conn)
    end
  end

  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      [] -> {:error, :token_not_found}
    end
  end

  def throw_error(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{})
    |> halt()
  end
end
