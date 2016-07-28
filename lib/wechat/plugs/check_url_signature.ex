defmodule Wechat.Plugs.CheckUrlSignature do
  import Plug.Conn

  def init(opts) do
    Keyword.merge(opts, token: Wechat.config[:token])
  end

  def call(conn = %Plug.Conn{params: params}, [token: token]) do
    IO.inspect conn
    %{"timestamp" => timestamp, "nonce" => nonce,
      "signature" => signature} = params
    my_signature = sign [token, timestamp, nonce]
    IO.puts my_signature
    IO.puts signature
    case my_signature == signature do
      true ->
        conn
      false ->
        conn
        |> send_resp(400, "")
        |> halt
    end
  end

  defp sign(args) do
    args
    |> Enum.sort
    |> Enum.join
    |> sha1
  end

  defp sha1(str) do
    :crypto.hash(:sha, str)
    |> Base.encode16(case: :lower)
  end
end
