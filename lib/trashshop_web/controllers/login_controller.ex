defmodule TrashShopWeb.LoginController do
  use TrashShopWeb, :controller
  use Params

  import Ecto.Changeset

  defparams(
    login_schema(%{
      email!: :string,
      password!: :string
    })
  )

  def create(conn, _params) do
    case validate_params(conn.body_params) do
      :ok ->
        %{"email" => email, "password" => password} = conn.body_params

        case TrashShop.User.find(email: email, password: password) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Usuário não encontrado"})

          _user ->
            {:ok, token, _claims} = TrashShop.Guardian.encode_and_sign(%{email: email})

            conn
            |> put_status(:ok)
            |> json(%{data: %{token: token}})
        end

      {:error, errors} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: errors})
    end
  end

  def validate_params(data) do
    data
    |> login_schema()
    |> validate_format(:email, ~r/@/)
    |> traverse_errors(fn
      {_msg, [validation: :required]} ->
        "Campo obrigatorio"

      {_msg, [validation: :format]} ->
        "Formato inválido"
    end)
    |> format_errors()
  end

  def format_errors(errors) when errors == %{}, do: :ok

  def format_errors(errors) do
    {:error, Enum.into(Enum.map(errors, fn {k, [msg]} -> {k, msg} end), %{})}
  end

  def find_user(%{email: email, password: password}) do
    TrashShop.User.find(email: email, password: password)
  end
end
