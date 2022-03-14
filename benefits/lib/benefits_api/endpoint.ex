defmodule BenefitsAPI.Endpoint do
  use Phoenix.Endpoint, otp_app: :benefits

  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Phoenix.json_library()
  )

  plug(BenefitsAPI.Router)
end
