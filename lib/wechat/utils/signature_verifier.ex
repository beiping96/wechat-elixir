defmodule Wechat.Utils.SignatureVerifier do
  @moduledoc """
  Verify wechat signature.
  """
  alias Plug.Crypto, as: PCrypto

  def verify?(args, signature) do
    args
    |> Enum.sort
    |> Enum.join
    |> sha1
    |> PCrypto.secure_compare(signature)
  end

  defp sha1(str) do
    digest = :crypto.hash(:sha, str)
    Base.encode16(digest, case: :lower)
  end
end
