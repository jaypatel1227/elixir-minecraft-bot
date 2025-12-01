defmodule ElixirMinecraftBot.DiscordClientMock do
  @behaviour ElixirMinecraftBot.DiscordClient

  def create_message(_channel_id, _content) do
    {:ok, %{}}
  end
end
