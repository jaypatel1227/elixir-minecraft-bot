FROM elixir:1.19-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config/config.exs config/runtime.exs config/

ENV MIX_ENV=prod
RUN mix deps.get --only prod && mix deps.compile

COPY lib lib

RUN mix release

FROM elixir:1.19-alpine

RUN apk add --no-cache docker-cli

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/elixir_minecraft_bot ./

CMD ["bin/elixir_minecraft_bot", "start"]
