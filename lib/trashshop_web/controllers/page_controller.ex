defmodule TrashShopWeb.PageController do
  use TrashShopWeb, :controller

  def index(conn, _params) do
    json(conn, %{a: 1})
  end
end
