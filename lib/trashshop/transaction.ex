defmodule TrashShop.Transaction do
  use Ecto.Schema

  alias TrashShop.Repo
  import Ecto.Changeset

  # TODO: Unique id
  schema "transactions" do
    field :unique_id, :string
    belongs_to :product, TrashShop.Product
    belongs_to :user, TrashShop.User

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:product_id, :user_id])
    |> validate_required([:product_id, :user_id])
    |> unique_constraint(:unique_id)
  end

  def create(user_id: user_id, product_id: product_id) do
    %TrashShop.Transaction{}
    |> changeset(%{user_id: user_id, product_id: product_id})
    |> Repo.insert()
  end
end
