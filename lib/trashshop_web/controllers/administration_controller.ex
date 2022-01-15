defmodule TrashShopWeb.AdministrationController do
  use TrashShopWeb, :controller

  alias TrashShop.User

  alias TrashShopWeb.HTTPErrors

  def show(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("index.json", administration: User.get_all())
  end

  def delete(conn, %{"id" => id}) do
    case User.delete(id) do
      {:ok, _user} ->
        resp(conn, :ok, "")

      {:error, :not_found} ->
        HTTPErrors.not_found(conn, "Usuário não encontrado")
    end
  end
end
