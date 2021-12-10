defmodule TrashShopWeb.PageController do
  use TrashShopWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn)

    json(conn, %{a: 1})
  end
end
