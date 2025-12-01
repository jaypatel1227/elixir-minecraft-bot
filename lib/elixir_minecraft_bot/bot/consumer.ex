defmodule ElixirMinecraftBot.Bot.Consumer do
  alias Nostrom.Api
  alias ElixirMinecraftBot.Rcon.RconAPI

  def start_link() do
    Consumer.start_link(__MODULE__)
  end

  def handle_event() do
  end

  # not trying to handle other kinds of events like MESSAGE_UPDATE, MESSAGE_REACTION_ADD or whatever for now
  def handle_event(_), do: :noop
end
