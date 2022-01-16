defmodule TrashShop.Product do
  use Ecto.Schema

  alias TrashShop.Repo
  import Ecto.Changeset
  import Ecto.Query

  schema "products" do
    field :code, :string
    field :name, :string
    field :price, :float

    belongs_to :user, TrashShop.User

    has_many :transactions, TrashShop.Transaction

    timestamps()
  end

  def changeset(product, params \\ %{}) do
    product
    |> cast(params, [:code, :name, :price, :user_id])
    |> validate_required([:code, :name, :price, :user_id])
    |> unique_constraint(:code)
  end

  def register(%{"name" => name, "price" => price, "user_id" => user_id}) do
    insert(%{
      name: name,
      price: price,
      user_id: user_id,
      code: Ecto.UUID.generate()
    })
  end

  def insert(product) do
    %TrashShop.Product{}
    |> changeset(product)
    |> Repo.insert()
  end

  def get_all() do
    query =
      from p in TrashShop.Product,
        join: u in TrashShop.User,
        on: p.user_id == u.id,
        select: %{
          p
          | user: %{
              name: u.name
            }
        }

    Repo.all(query)
  end

  def find(code: code) do
    query =
      from p in TrashShop.Product,
        where: p.code == ^code,
        join: u in TrashShop.User,
        on: p.user_id == u.id,
        select: %{
          p
          | user: %{
              name: u.name
            }
        }

    Repo.one(query)
  end

  def find(user_id: user_id) do
    query =
      from p in TrashShop.Product,
        where: p.user_id == ^user_id

    Repo.all(query)
  end

  def delete(product) do
    Repo.delete(product)
  end
end
