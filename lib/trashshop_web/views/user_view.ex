defmodule TrashShopWeb.UserView do
  use TrashShopWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      age: user.age,
      email: user.email,
      balance: user.balance,
      password: user.password
    }
  end
end
