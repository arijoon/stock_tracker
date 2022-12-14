FROM elixir:1.14.1-alpine AS builder

ENV MIX_ENV=prod \
    APP_NAME=stock_tracker

WORKDIR /opt/app

# COPY shell.nix default.nix ./
# COPY nix ./

# RUN nix-shell --command "echo loaded deps"


COPY mix.exs mix.lock ./

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get && mix deps.compile

COPY . .

RUN mix compile && mix release

RUN \
  mkdir -p /opt/built && \
  cp -rf _build/${MIX_ENV}/rel/${APP_NAME} /opt/built

FROM alpine:3.16.2
RUN apk add --update postgresql-client bash

ENV APP_NAME=stock_tracker

WORKDIR /opt/app

COPY waitdb.sh .
COPY --from=builder /opt/built .

CMD ["/bin/bash", "/opt/app/waitdb.sh"]

