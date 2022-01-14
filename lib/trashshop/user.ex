defmodule TrashShop.User do
  use Ecto.Schema

  alias TrashShop.Repo
  import Ecto.Changeset
  import Ecto.Query

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string
    field :balance, :integer, default: 0

    has_many :transactions, TrashShop.Transaction

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :age, :email, :password, :balance])
    |> validate_required([:name, :age, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def find(id: id), do: Repo.get(TrashShop.User, id)

  def find(email: email) do
    query =
      from u in TrashShop.User,
        where: u.email == ^email

    Repo.one(query)
  end

  def find_and_check_credential(email: email, password: password) do
    case find(email: email) do
      nil ->
        nil

      user ->
        case check_password(user.password, password) do
          {:ok, %{password_hash: _password_hash}} -> user
          {:error, "invalid password"} -> nil
        end
    end
  end

  def check_password(hash, password) do
    Argon2.check_pass(%{password_hash: hash}, password)
  end

  def create(user) do
    %TrashShop.User{}
    |> changeset(%{user | password: make_password_hash(user.password)})
    |> Repo.insert()
  end

  def make_password_hash(pass) do
    pass
    |> Argon2.add_hash()
    |> Map.get(:password_hash)
  end

  def email_exists?(email) do
    query =
      from u in TrashShop.User,
        where: u.email == ^email

    Repo.exists?(query)
  end

  def user_exists?(id) do
    query =
      from u in TrashShop.User,
        where: u.id == ^id

    Repo.exists?(query)
  end

  def get_all(), do: Repo.all(TrashShop.User)

  def delete(id) do
    case find(id: id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
