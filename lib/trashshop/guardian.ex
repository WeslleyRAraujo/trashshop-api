defmodule TrashShop.Guardian do
  use Guardian, otp_app: :trashshop

  def subject_for_token(%{id: id}, _claims) do
    {:ok, id}
  end

  def subject_for_token(_, _), do: {:error, :invalid}

  def resource_from_claims(%{"sub" => id}) do
    {:ok, TrashShop.User.find(id: id)}
  end
end
