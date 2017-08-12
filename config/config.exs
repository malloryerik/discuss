# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eXA9kJ1Ai7v9HMlbJCY+lPqqTqOIMFW/OxKJyK4qeMjRbAeEdiA7PtgVpmsrRV4x",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [] }
  ]

  # DO Not Commit to GitHub -- hide API keys
  config :ueberauth, Ueberauth.Strategy.Github.OAuth,
    client_id: "6894fae0cfff6741772e",
    client_secret: "b3c281b92223df96be576f85f4eb30b92ce59109"
  