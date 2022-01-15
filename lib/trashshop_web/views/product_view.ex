defmodule TrashShopWeb.ProductView do
  use TrashShopWeb, :view

  def render("index.json", %{product: products}) do
    %{products: render_many(products, __MODULE__, "product.json")}
  end

  def render("product.json", %{product: nil}), do: %{}

  def render("product.json", %{product: product}) do
    %{
      code: product.code,
      name: product.name,
      price: product.price,
      user_id: product.user_id,
      user: show_user(product)
    }
  end

  def show_user(product) do
    case product.user do
      %Ecto.Association.NotLoaded{} -> %{}
      _ -> product.user
    end
  end
end
