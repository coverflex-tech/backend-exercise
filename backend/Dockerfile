FROM hexpm/elixir:1.11.3-erlang-23.2.4-alpine-3.13.1 as build

WORKDIR /src

ENV MIX_ENV=prod
ENV PORT=4000

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.exs mix.exs
COPY mix.lock mix.lock

RUN mix deps.get --only prod
RUN mix deps.compile

COPY config config
COPY lib lib
COPY priv priv

RUN mix compile
RUN mix release

FROM alpine:3.13.1 as app

RUN apk add --update bash

WORKDIR /app

COPY --from=build /src/_build/prod/rel/backend/ .
COPY /docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /app/bin

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./backend", "start"]