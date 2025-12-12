defmodule ElixirMinecraftBot.Bot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api.Message
  alias ElixirMinecraftBot.Rcon.RconAPI
  alias ElixirMinecraftBot.ServerControl
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
                "Failed to op the user. RCON Error: \n```#{error}```"
              )
          end

        "!tp " <> args ->
          case String.split(args, " ", parts: 2) do
            [player, destination] ->
              case RconAPI.tp(player, destination) do
                {:ok, response} -> Message.create(msg.channel_id, "RCON: \n```#{response}```")
                {:error, error} -> Message.create(msg.channel_id, "TP failed: \n```#{error}```")
              end
            _ ->
              Message.create(msg.channel_id, "Usage: !tp <player> <destination>")
          end

        "!day" ->
          case RconAPI.set_time_day() do
            {:ok, response} -> Message.create(msg.channel_id, "RCON: \n```#{response}```")
            {:error, error} -> Message.create(msg.channel_id, "Failed: \n```#{error}```")
          end

        "!say " <> message ->
          case RconAPI.say(message) do
            {:ok, _} -> Message.create(msg.channel_id, "Message sent to server")
            {:error, error} -> Message.create(msg.channel_id, "Failed: \n```#{error}```")
          end

        "!whisper " <> args ->
          case String.split(args, " ", parts: 2) do
            [player, message] ->
              case RconAPI.whisper(player, message) do
                {:ok, _} -> Message.create(msg.channel_id, "Whispered to #{player}")
                {:error, error} -> Message.create(msg.channel_id, "Failed: \n```#{error}```")
              end
            _ ->
              Message.create(msg.channel_id, "Usage: !whisper <player> <message>")
          end

        "!weather " <> type when type in ["clear", "rain", "thunder"] ->
          case RconAPI.weather(type) do
            {:ok, response} -> Message.create(msg.channel_id, "RCON: \n```#{response}```")
            {:error, error} -> Message.create(msg.channel_id, "Failed: \n```#{error}```")
          end

        "!weather " <> _ ->
          Message.create(msg.channel_id, "Usage: !weather <clear|rain|thunder>")

        "!restart" ->
          Message.create(msg.channel_id, "Restarting server...")
          ServerControl.restart_server()
          Message.create(msg.channel_id, "Server restart initiated")

        "!stop" ->
          Message.create(msg.channel_id, "Stopping server...")
          ServerControl.stop_server()
          Message.create(msg.channel_id, "Server stopped")

        "!start" ->
          Message.create(msg.channel_id, "Starting server...")
          ServerControl.start_server()
          Message.create(msg.channel_id, "Server start initiated")

        "!backup" ->
          Message.create(msg.channel_id, "Creating backup...")
          ServerControl.backup_world()
          Message.create(msg.channel_id, "Backup complete")

        "!help" ->
          help_text = """
          **Available Commands:**
          `!status` - Shows players currently online
          `!whitelist <user>` - Add player to whitelist
          `!op <user>` - Grant operator permissions
          `!tp <player> <dest>` - Teleport a player
          `!day` - Set time to day
          `!say <message>` - Broadcast message to server
          `!whisper <player> <msg>` - Private message a player
          `!weather <clear|rain|thunder>` - Change weather
          `!restart` - Restart the server
          `!stop` - Stop the server
          `!start` - Start the server
          `!backup` - Create world backup
          `!help` - Show this help message
          """
          Message.create(msg.channel_id, help_text)

        _ ->
          :ignore
      end
    end
  end

  def handle_event(_), do: :noop
end
