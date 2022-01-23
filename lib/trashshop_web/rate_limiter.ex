defmodule ThingWeb.RateLimiter do
  alias TrashShopWeb.HTTPErrors

  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_token()
    |> check_ip()
    |> case do
      :allow ->
        conn

      :deny ->
        HTTPErrors.rate_limiter(conn)
    end
  end

  def get_token(conn), do: conn.assigns.token

  def get_ip(conn) do
    conn.remote_ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp check_ip(identifier) do
    Logger.info("Identifier: #{identifier}")

    case Hammer.check_rate(identifier, 60_000, 4) do
      {:allow, _count} ->
        :allow

      {:deny, _limit} ->
        :deny
    end
  end
end
