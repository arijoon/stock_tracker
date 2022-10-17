import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stock_tracker, StockTracker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "192.168.0.2",
  database: "stock_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stock_tracker, StockTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "4sxGUfONy89khpaJbsdfVH8veOgFF3shQDsv3gN5fdnrJT6X4RJM8K5H3CduY8a2",
  server: false

# In test we don't send emails.
config :stock_tracker, StockTracker.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :stock_tracker, :targets, []
config :stock_tracker, :notification_address, "http://localhost/notification"
