import Config

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: [:guild_messages, :message_content, :guilds]

config :rcon,
  host: System.get_env("RCON_HOST") || "localhost",
  port: String.to_integer(System.get_env("RCON_PORT") || "25575"),
  password: System.get_env("RCON_PASSWORD")
