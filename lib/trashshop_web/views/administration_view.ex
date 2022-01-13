defmodule TrashShopWeb.AdministrationView do
  use TrashShopWeb, :view

  def render("index.json", %{administration: users}) do
    %{users: render_many(users, __MODULE__, "user.json")}
  end

  def render("user.json", %{administration: user}) do
    %{
      id: user.id,
      name: user.name,
      age: user.age,
      email: user.email,
      balance: user.balance
    }
  end
end
