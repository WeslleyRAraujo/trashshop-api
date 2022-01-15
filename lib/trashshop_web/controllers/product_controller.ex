defmodule TrashShopWeb.ProductController do
  use TrashShopWeb, :controller
  use Params

  import Ecto.Changeset

  defparams(
    product_creation_schema(%{
      name!: :string,
      price!: :integer
    })
  )

  def create(conn, _params) do
    case validate_params(conn.body_params) do
      :ok ->
        {:ok, product} = TrashShop.Product.register(conn.body_params)

        conn
        |> put_status(:created)
        |> json(%{data: take_relevant_data(product)})

      {:error, errors} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: errors})
    end
  end

  def show(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("index.json", product: TrashShop.Product.get_all())
  end

  def validate_params(data) do
    data
    |> product_creation_schema()
    |> validate_change(:price, fn :price, price ->
      if price > 0, do: [], else: [price: "Preço inválido"]
    end)
    |> traverse_errors(fn {_msg, [validation: :required]} -> "Campo obrigatorio" end)
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
