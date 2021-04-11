# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tasktracker,
  ecto_repos: [Tasktracker.Repo]

# Configures the endpoint
config :tasktracker, TasktrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aGkzLlK5H4x5Er+k5E61O5Z1HGqv4mDAom3qtFa1uUF0l4DF0H47B1TPeWQ4kP9w",
  render_errors: [view: TasktrackerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Tasktracker.PubSub,
  live_view: [signing_salt: "dHLc8izo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
