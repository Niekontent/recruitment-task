FROM elixir:1.19.5

WORKDIR /app

# Install Hex + Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix.exs files
COPY mix.exs mix.lock ./

# Fetch deps
RUN mix deps.get

# Copy rest of the app
COPY . .

EXPOSE 4000

CMD ["mix", "phx.server"]
