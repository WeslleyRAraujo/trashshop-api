defmodule TrashShopWeb.AdministrationController do
  use TrashShopWeb, :controller

  alias TrashShop.User

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
        resp(conn, :not_found, "")
    end
  end
end
