defmodule ElixirMinecraftBot.ServerControl do
  alias ElixirMinecraftBot.Rcon.RconAPI

  def restart_server do
    {:ok, _response} = RconAPI.run_command("save-all")
    System.cmd("docker", ["restart", "minecraft"])
  end

  def stop_server do
    {:ok, _response} = RconAPI.run_command("save-all")
    System.cmd("docker", ["stop", "minecraft"])
  end

  def start_server do
    System.cmd("docker", ["start", "minecraft"])
  end

  def backup_world do
    timestamp = DateTime.utc_now() |> Calendar.strftime("%Y%m%d_%H%M%S")
    {:ok, _response} = RconAPI.run_command("save-all")
    System.cmd("tar", ["-czf", "/backups/world-#{timestamp}.tar.gz", "-C", "/minecraft-data", "world"])
  end
end
