FROM hexpm/elixir:1.13.3-erlang-24.2.2-alpine-3.15.0

WORKDIR /app

COPY mix.exs mix.lock 

RUN mix local.hex --force && \
  mix local.rebar --force

RUN apk update \
  && apk add --no-cache postgresql-client ca-certificates inotify-tools \
  && update-ca-certificates 

COPY . .

CMD mix deps.get && mix ecto.setup && mix phx.server
