import Config

config :nostrum,
  token: "Bot dummy_token_for_tests",
  gateway_intent: :all

config :rcon,
  host: "localhost",
  port: 25575,
  password: "password"

config :elixir_minecraft_bot, :discord_client, ElixirMinecraftBot.DiscordClientMock

config :elixir_minecraft_bot, :start_rcon, false
