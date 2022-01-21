defmodule TrashShopWeb.UserView do
  use TrashShopWeb, :view

  def render("index.json", %{user: users}) do
    %{users: render_many(users, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      age: user.age,
      email: user.email,
      balance: user.balance
    }
  end
end
