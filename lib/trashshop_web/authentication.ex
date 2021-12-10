defmodule TrashShopWeb.Authentication do
  import Plug.Conn
  alias TrashShop.Guardian, as: GuardianModule

  def authenticate(conn, _opts) do
    with {:ok, token} <- get_token(conn),
         {:ok, claims} <- GuardianModule.decode_and_verify(token),
         {:ok, user} <- GuardianModule.resource_from_claims(claims) do
        assign(conn, :user, user)
    else
      {:error, :token_not_found} -> :error
      _ -> :error
    end
  end

  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      [] -> {:error, :token_not_found}
    end
  end
end
