defmodule ElixirMinecraftBot.ServerControl do
  alias ElixirMinecraftBot.Rcon.RconAPI

  def restart_server do
    RconAPI.run_command("save-all")
    Process.sleep(2000)
    System.cmd("docker", ["restart", "minecraft"])
  end

  def stop_server do
    RconAPI.run_command("save-all")
    Process.sleep(2000)
    System.cmd("docker", ["stop", "minecraft"])
  end

  def start_server do
    System.cmd("docker", ["start", "minecraft"])
  end

  def backup_world do
    timestamp = DateTime.utc_now() |> Calendar.strftime("%Y%m%d_%H%M%S")
    RconAPI.run_command("save-all")
    Process.sleep(2000)
    System.cmd("cp", ["-r", "/minecraft-data/world", "/backups/world-#{timestamp}"])
  end
end
