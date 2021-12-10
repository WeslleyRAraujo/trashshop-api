defmodule TrashShop.Guardian do
  use Guardian, otp_app: :trashshop

  def subject_for_token(%{email: email}, _claims) do
    {:ok, email}
  end

  def subject_for_token(_, _), do: {:error, :invalid}

  def resource_from_claims(%{"sub" => email}) do
    {:ok, TrashShop.User.find(email: email)}
  end
end
