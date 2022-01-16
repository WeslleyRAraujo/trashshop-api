defmodule TrashShopWeb.ProductController do
  use TrashShopWeb, :controller
  use Params

  import Ecto.Changeset

  alias TrashShop.Product
  alias TrashShopWeb.HTTPErrors

  defparams(
    product_creation_schema(%{
      name!: :string,
      price!: :float,
      user_id!: :integer
    })
  )

  def create(conn, _params) do
    case validate_params(conn.body_params) do
      :ok ->
        {:ok, product} = Product.register(conn.body_params)

        conn
        |> put_status(:created)
        |> json(%{data: take_relevant_data(product)})

      {:error, errors} ->
        HTTPErrors.bad_request(conn, errors)
    end
  end

  def show(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("index.json", product: Product.get_all())
  end

  def show_by_id(conn, %{"code" => code}) do
    conn
    |> put_status(:ok)
    |> render("product.json", product: Product.find(code: code))
  end

  def show_by_user(conn, %{"user_id" => user_id}) do
    conn
    |> put_status(:ok)
    |> render("index.json", product: Product.find(user_id: user_id))
  end

  def delete(conn, %{"code" => code}) do
    case Product.find(code: code) do
      nil ->
        HTTPErrors.not_found(conn)

      product ->
        if product.user_id == conn.assigns.user.id do
          {:ok, _product} = Product.delete(product)

          resp(conn, :ok, "")
        else
          HTTPErrors.unauthorized(conn)
        end
    end
  end

  def validate_params(data) do
    data
    |> product_creation_schema()
    |> validate_change(:price, fn :price, price ->
      if price > 0, do: [], else: [price: "Preço inválido"]
    end)
    |> validate_change(:user_id, fn :user_id, user_id ->
      if TrashShop.User.user_exists?(user_id), do: [], else: [user_id: "Usuário não encontrado"]
    end)
    |> traverse_errors(fn
      {_msg, [validation: :required]} -> "Campo obrigatorio"
      {msg, _} -> msg
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
      :price,
      :code
    ])
  end
end
