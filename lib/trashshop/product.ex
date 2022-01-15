defmodule TrashShop.Product do
  use Ecto.Schema

  alias TrashShop.Repo
  import Ecto.Changeset

  schema "products" do
    field :code, :string
    field :name, :string
    field :price, :integer

    has_many :transactions, TrashShop.Transaction

    timestamps()
  end

  def changeset(product, params \\ %{}) do
    product
    |> cast(params, [:code, :name, :price])
    |> validate_required([:code, :name, :price])
    |> unique_constraint(:code)
  end

  def register(%{"name" => name, "price" => price}) do
    insert(%{
      name: name,
      price: price,
      code: Ecto.UUID.generate()
    })
  end

  def insert(product) do
    %TrashShop.Product{}
    |> changeset(product)
    |> Repo.insert()
  end

  def get_all(), do: Repo.all(TrashShop.Product)
end
