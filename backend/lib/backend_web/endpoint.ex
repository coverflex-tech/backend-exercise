defmodule BackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backend

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug BackendWeb.Router
end
