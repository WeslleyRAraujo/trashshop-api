defmodule TrashShopWeb.UserController do
  use TrashShopWeb, :controller
  use Params

  import Ecto.Changeset

  alias TrashShopWeb.HTTPErrors

  defparams(
    user_creation_schema(%{
      name!: :string,
      age!: :integer,
      email!: :string,
      password!: :string
    })
  )

  def create(conn, _params) do
    case validate_params(conn.body_params) do
      :ok ->
        {:ok, user} =
          conn.body_params
          |> format_user_payload()
          |> TrashShop.User.create()

        conn
        |> put_status(:created)
        |> json(%{data: take_relevant_data(user)})

      {:error, errors} ->
        HTTPErrors.bad_request(conn, errors)
    end
  end

  def format_user_payload(body_params) do
    %{
      name: body_params["name"],
      email: body_params["email"],
      password: body_params["password"],
      age: body_params["age"]
    }
  end

  def info(conn, %{"id" => id}) do
    case TrashShop.User.find(id: id) do
      nil ->
        HTTPErrors.not_found(conn)

      user ->
        render(conn, "user.json", user: user)
    end
  end

  def validate_params(data) do
    data
    |> user_creation_schema()
    |> validate_change(:email, fn :email, email ->
      if TrashShop.User.registered_email?(email),
        do: [email: "E-mail ja cadastrado no sistema"],
        else: []
    end)
    |> validate_change(:email, fn :email, email ->
      if Regex.match?(~r/@/, email), do: [], else: [email: "Formato de e-mail inválido"]
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
    {:error,
     errors
     |> Enum.map(fn {k, [msg]} -> {k, msg} end)
     |> Enum.into(%{})}
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
