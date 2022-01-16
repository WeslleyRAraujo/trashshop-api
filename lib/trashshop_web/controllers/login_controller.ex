defmodule TrashShopWeb.LoginController do
  use TrashShopWeb, :controller
  use Params

  import Ecto.Changeset

  alias TrashShop.User
  alias TrashShop.Guardian, as: GuardianModule
  alias TrashShopWeb.HTTPErrors

  defparams(
    login_schema(%{
      email!: :string,
      password!: :string
    })
  )

  def create(conn, _params) do
    with :ok <- validate_params(conn.body_params),
         {:ok, user} <-
           check_credentials(conn.body_params["email"], conn.body_params["password"]),
         {:ok, token, _claims} <-
           GuardianModule.encode_and_sign(%{id: user.id}, %{}, ttl: {15, :minute}) do
      conn
      |> put_status(:ok)
      |> json(%{data: %{token: token}})
    else
      {:error, :not_found} ->
        HTTPErrors.not_found(conn, "Usuário não encontrado")

      {:error, :invalid_password} ->
        HTTPErrors.unauthorized(conn, "Senha incorreta")

      {:error, errors} ->
        HTTPErrors.bad_request(conn, errors)

      _ ->
        HTTPErrors.bad_request(conn)
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

  def check_credentials(email, password) do
    case User.find_and_check_credential(email: email, password: password) do
      {:error, error} -> {:error, error}
      user -> {:ok, user}
    end
  end
end
