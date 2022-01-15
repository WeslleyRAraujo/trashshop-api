defmodule TrashShopWeb.HTTPErrors do
  use TrashShopWeb, :controller

  def throw_error(conn, error, status) do
    conn
    |> put_status(status)
    |> json(%{error: error})
    |> halt()
  end

  def not_found(conn, message \\ "not_found") do
    throw_error(conn, message, 404)
  end

  def bad_request(conn, message \\ "bad_request") do
    throw_error(conn, message, 400)
  end

  def unauthorized(conn, message \\ "unauthorized") do
    throw_error(conn, message, 401)
  end
end
