defmodule ElixirMinecraftBot.Rcon.RconConnectionMock do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: ElixirMinecraftBot.Rcon.RconConnection)
  end

  def send_command(command) do
    GenServer.call(__MODULE__, {:cmd, command})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:cmd, command}, _from, state) do
    response = case command do
      "list" -> "There are 0 of a max of 20 players online: "
      "op " <> username -> "Made #{username} a server operator"
      "whitelist add " <> username -> "Added #{username} to the whitelist"
      _ -> "Unknown command"
    end
    {:reply, {:ok, response}, state}
  end
end
