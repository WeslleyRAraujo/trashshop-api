defmodule TrashShop.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :name, :string
      add :age, :integer
      add :email, :string
      add :password, :string
      add :balance, :integer

      timestamps()
    end

    create table("products") do
      add :code, :string
      add :name, :string
      add :price, :integer

      timestamps()
    end

    create table("transactions") do
      add :unique_id, :string
      add :product_id, references(:products)
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index("users", [:email], name: :users_constraint)

    create unique_index("products", [:code], name: :products_constraint)

    create unique_index("transactions", [:unique_id], name: :transactions_constraint)
  end
end
