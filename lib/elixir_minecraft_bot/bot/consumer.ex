defmodule ElixirMinecraftBot.Bot.Consumer do
  alias Nostrum.Api.Message
  alias ElixirMinecraftBot.Rcon.RconAPI
  require Logger

  def start_link() do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Logger.info("Processing event for message: #{msg.content}")

    unless msg.author.bot do
      case msg.content do
        "!status" ->
          case RconAPI.get_status() do
            {:ok, response} ->
              Message.create(msg.channel_id, "Server says: \n```#{response}```")

            {:error, error} ->
              Message.create(
                msg.channel_id,
                "Failed to fetch the status of the server. RCON Error: \n```#{error}```"
              )
          end

        "!whitelist " <> username ->
          case RconAPI.whitelist_user(username) do
            {:ok, response} ->
              Message.create(msg.channel_id, "RCON: \n```#{response}```")

            {:error, error} ->
              Message.create(
                msg.channel_id,
                "Failed to whitelist the user. RCON Error: \n```#{error}```"
              )
          end

        "!op " <> username ->
          case RconAPI.op_user(username) do
            {:ok, response} ->
              Message.create(msg.channel_id, "RCON: \n```#{response}```")

            {:error, error} ->
              Message.create(
                msg.channel_id,
                "Failed to whitelist the user. RCON Error: \n```#{error}```"
              )
          end

        _ ->
          :ignore
      end
    end
  end

  # not trying to handle other kinds of events like MESSAGE_UPDATE, MESSAGE_REACTION_ADD or whatever for now
  def handle_event(_), do: :noop
end
