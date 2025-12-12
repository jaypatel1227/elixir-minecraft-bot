defmodule ElixirMinecraftBot.ServerControl do
  alias ElixirMinecraftBot.Rcon.RconAPI
  alias ElixirMinecraftBot.Rcon.RconConnection

  def restart_server do
    {:ok, _response} = RconAPI.run_command("save-all")
    result = System.cmd("docker", ["restart", "minecraft"])
    RconConnection.reconnect()
    result
  end

  def stop_server do
    {:ok, _response} = RconAPI.run_command("save-all")
    result = System.cmd("docker", ["stop", "minecraft"])
    RconConnection.reconnect()
    result
  end

  def start_server do
    result = System.cmd("docker", ["start", "minecraft"])
    RconConnection.reconnect()
    result
  end

  def backup_world do
    timestamp = DateTime.utc_now() |> Calendar.strftime("%Y%m%d_%H%M%S")
    {:ok, _response} = RconAPI.run_command("save-all")
    System.cmd("tar", ["-czf", "/backups/world-#{timestamp}.tar.gz", "-C", "/minecraft-data", "world"])
  end
end
