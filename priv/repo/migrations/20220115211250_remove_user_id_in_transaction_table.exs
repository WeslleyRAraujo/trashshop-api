defmodule TrashShop.Repo.Migrations.RemoveUserIdInTransactionTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :user_id
    end
  end
end
