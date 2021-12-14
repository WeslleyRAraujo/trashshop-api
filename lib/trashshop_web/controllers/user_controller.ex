defmodule TrashShopWeb.UserController do
  use TrashShopWeb, :controller
  use Params

  import Ecto.Changeset

  defparams user_creation_schema %{
    name!: :string,
    age!: :integer,
    email!: :string,
    password!: :string
  }

  def create(conn, _params) do
    case validate_params(conn.body_params) do 
      :ok ->
        {:ok, user} = TrashShop.User.create(conn.body_params)

        conn
        |> put_status(:created)
        |> json(%{data: take_relevant_data(user)})

      {:error, errors} ->
        conn
        |> put_status(:ok)
        |> json(%{error: errors})
    end
  end

  def validate_params(data) do
    data
    |> user_creation_schema()
    |> validate_change(:email, fn :email, email -> 
      if TrashShop.User.email_exists?(email), do: [email: "E-mail ja cadastrado no sistema"], else: []
    end)
    |> validate_change(:age, fn :age, age -> 
      if is_integer(age), do: [], else: [age: "Idade inválida"]
    end)
    |> traverse_errors(fn
      {_msg, [validation: :required]} ->
        "Campo obrigatorio"

      {msg, _reason} ->
        msg
    end)
    |> format_errors()
  end

  def format_errors(errors) when errors == %{}, do: :ok

  def format_errors(errors) do
    {:error, Enum.into(Enum.map(errors, fn {k, [msg]} -> {k, msg} end), %{})}
  end

  def take_relevant_data(user) do
    user
    |> Map.from_struct()
    |> Map.take([
      :name,
      :email
    ])
  end
end
