import Config

if config_env() != :test do
  config :nostrum,
    token: System.get_env("DISCORD_TOKEN") || raise("DISCORD_TOKEN is required"),
    consumer: ElixirMinecraftBot.Bot.Consumer,
    gateway_intents: [:guild_messages, :message_content, :guilds]

  config :rcon,
    host: System.get_env("RCON_HOST") || "localhost",
    port: String.to_integer(System.get_env("RCON_PORT") || "25575"),
    password: System.get_env("RCON_PASSWORD") || raise("RCON_PASSWORD is required")
end
