defmodule ElixirMinecraftBot.Bot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api.Message
  alias ElixirMinecraftBot.Rcon.RconAPI
  require Logger

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Logger.info("Received message from user #{msg.author.username}: #{msg.content}")

    unless msg.author.bot do
      case msg.content do
        "!status" ->
          Logger.info("Processing !status command")

          case RconAPI.get_status() do
            {:ok, response} ->
              Logger.info("Status command successful: #{response}")
              Message.create(msg.channel_id, "Server says: \n```#{response}```")

            {:error, error} ->
              Logger.error("Status command failed: #{inspect(error)}")

              Message.create(
                msg.channel_id,
                "Failed to fetch the status of the server. RCON Error: \n```#{error}```"
              )
          end

        "!whitelist " <> username ->
          Logger.info("Processing !whitelist command for user: #{username}")

          case RconAPI.whitelist_user(username) do
            {:ok, response} ->
              Logger.info("Whitelist command successful for #{username}: #{response}")
              Message.create(msg.channel_id, "RCON: \n```#{response}```")

            {:error, error} ->
              Logger.error("Whitelist command failed for #{username}: #{inspect(error)}")

              Message.create(
                msg.channel_id,
                "Failed to whitelist the user. RCON Error: \n```#{error}```"
              )
          end

        "!op " <> username ->
          Logger.info("Processing !op command for user: #{username}")

          case RconAPI.op_user(username) do
            {:ok, response} ->
              Logger.info("Op command successful for #{username}: #{response}")
              Message.create(msg.channel_id, "RCON: \n```#{response}```")

            {:error, error} ->
              Logger.error("Op command failed for #{username}: #{inspect(error)}")

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
