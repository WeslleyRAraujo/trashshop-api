defmodule ThingWeb.RateLimiter do
  alias TrashShopWeb.HTTPErrors

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_ip()
    |> check_ip()
    |> case do
      :allow ->
        conn

      :deny ->
        HTTPErrors.rate_limiter(conn)
    end
  end

  defp get_ip(conn) do
    conn.remote_ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp check_ip(ip) do
    case Hammer.check_rate(ip, 60_000, 4) do
      {:allow, _count} ->
        :allow

      {:deny, _limit} ->
        :deny
    end
  end
end
