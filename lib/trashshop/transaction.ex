defmodule TrashShop.Transaction do
  use Ecto.Schema

  alias TrashShop.Repo
  import Ecto.Changeset

  schema "transactions" do
    field :unique_id, :string
    belongs_to :product, TrashShop.Product

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:product_id])
    |> validate_required([:product_id])
    |> unique_constraint(:unique_id)
  end

  def create(user_id: user_id, product_id: product_id) do
    %TrashShop.Transaction{}
    |> changeset(%{
      user_id: user_id,
      product_id: product_id,
      unique_id: Ecto.UUID.generate()
    })
    |> Repo.insert()
  end
end
