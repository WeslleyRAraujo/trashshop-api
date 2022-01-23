defmodule TrashShopWeb.Plugs.Authentication do
  use TrashShopWeb, :controller
  import Plug.Conn
  alias TrashShop.Guardian, as: GuardianModule
  alias TrashShopWeb.HTTPErrors

  def init(options), do: options

  def call(conn, _opts), do: authenticate(conn)

  def authenticate(conn) do
    with {:ok, token} <- get_token(conn),
         {:ok, claims} <- GuardianModule.decode_and_verify(token),
         true <- check_if_user_exists(claims),
         {:ok, user} <- GuardianModule.resource_from_claims(claims) do
      conn
      |> assign(:user, user)
      |> assign(:token, token)
    else
      {:error, :token_not_found} ->
        HTTPErrors.unauthorized(conn)

      false ->
        HTTPErrors.unauthorized(conn)

      _ ->
        HTTPErrors.unauthorized(conn)
    end
  end

  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        {:ok, token}

      [] ->
        {:error, :token_not_found}

      _ ->
        {:error, :token_not_found}
    end
  end

  def check_if_user_exists(%{"sub" => id} = _claims) do
    if TrashShop.User.user_exists?(id), do: true, else: false
  end
end
