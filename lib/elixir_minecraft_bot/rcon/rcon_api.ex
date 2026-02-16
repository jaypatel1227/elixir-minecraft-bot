defmodule ElixirMinecraftBot.Rcon.RconAPI do
  alias ElixirMinecraftBot.Rcon.RconConnection
  require Logger

  @doc """
  Runs the inputted command on the server and returns the output.
  For now, it doesn't do any parsing or validation. However, in the future, we should filter it some people can't destroy the server accidently or otherwise.
  """
  def run_command(command) do
    Logger.info("Executing RCON command: #{command}")

    case RconConnection.send_command(command) do
      {:ok, response} ->
        Logger.info("RCON command executed successfully: #{command}")
        {:ok, response}

      {:error, reason} = error ->
        Logger.error("RCON command failed: #{command}, reason: #{inspect(reason)}")
        error
    end
  end

  @doc """
  Whitelists the specified user to be able to log in to the server. 
  mc_username - The username of the user should be passed in. This is not the GUID and can be found on your mojang/microsoft account for the game
  """
  def whitelist_user(mc_username) do
    Logger.info("Whitelisting user: #{mc_username}")
    run_command("whitelist add #{mc_username}")
  end

  @doc """
  Bans the specified user from the server.
  """
  def ban_user(mc_username, reason \\ nil) do
    cmd = if reason, do: "ban #{mc_username} #{reason}", else: "ban #{mc_username}"
    Logger.info("Banning user: #{mc_username}")
    run_command(cmd)
  end

  @doc """
  Kicks the specified user from the server.
  """
  def kick_user(mc_username, reason \\ nil) do
    cmd = if reason, do: "kick #{mc_username} #{reason}", else: "kick #{mc_username}"
    Logger.info("Kicking user: #{mc_username}")
    run_command(cmd)
  end

  @doc """
  Gives the user admin permissions to be able to run commands from the server itself.
  Should ideally be a very small list of people since this bot should expose most things people need
  mc_username - The username of the user should be passed in. This is not the GUID and can be found on your mojang/microsoft account for the game
  """
  def op_user(mc_username) do
    Logger.info("Granting op permissions to user: #{mc_username}")
    run_command("op #{mc_username}")
  end

  def get_status() do
    Logger.info("Fetching server status")
    run_command("list")
  end

  def tp(player, destination) do
    run_command("tp #{player} #{destination}")
  end

  def set_time_day() do
    run_command("time set day")
  end

  def say(message) do
    run_command("say #{message}")
  end

  def whisper(player, message) do
    run_command("tell #{player} #{message}")
  end

  def weather(type) when type in ~w(clear rain thunder) do
    run_command("weather #{type}")
  end
end
