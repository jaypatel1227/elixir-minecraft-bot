defmodule ElixirMinecraftBot.DiscordClient do
  @callback create_message(integer(), String.t()) :: {:ok, map()} | {:error, map()}

  def create_message(channel_id, content) do
    impl().create_message(channel_id, content)
  end

  defp impl do
    Application.get_env(:elixir_minecraft_bot, :discord_client, ElixirMinecraftBot.DiscordClient.Nostrum)
  end
end

defmodule ElixirMinecraftBot.DiscordClient.Nostrum do
  @behaviour ElixirMinecraftBot.DiscordClient
  alias Nostrum.Api.Message

  def create_message(channel_id, content) do
    Message.create(channel_id, content)
  end
end
