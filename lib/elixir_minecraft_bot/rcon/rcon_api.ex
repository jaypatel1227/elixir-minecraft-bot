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
end
