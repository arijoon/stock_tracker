FROM FROM elixir:alpine AS builder

ENV MIX_ENV=prod
    APP_NAME=stock_tracker

WORKDIR /opt/app

# COPY shell.nix default.nix ./
# COPY nix ./

# RUN nix-shell --command "echo loaded deps"

COPY . .

RUN mix deps.get && mix deps.compile && mix compile && mix release

RUN \
  mkdir -p /opt/built && \
  cp _build/${MIX_ENV}/rel/${APP_NAME} /opt/built

FROM alpine:3.16.2
RUN apk add --update postgresql-client

ENV APP_NAME=stock_tracker

WORKDIR /opt/app

COPY waitdb.sh .
COPY --from=builder /opt/built .

CMD trap 'exit' INT; ./waitdb.sh



