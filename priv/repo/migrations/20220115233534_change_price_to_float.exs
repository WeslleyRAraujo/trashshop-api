defmodule TrashShop.Repo.Migrations.ChangePriceToFloat do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :price, :float
    end
  end
end
