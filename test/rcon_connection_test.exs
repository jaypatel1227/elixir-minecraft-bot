defmodule ElixirMinecraftBotTest.RconConnectionTest do
  use ExUnit.Case

  alias ElixirMinecraftBot.Rcon.RconConnection

  test "RconConnection starts successfully" do
    # Verify that the GenServer can start
    assert {:ok, pid} = RconConnection.start_link([])
    assert Process.alive?(pid)
  end

  test "RconConnection handles :connect message without crashing" do
    # We can inspect the state or logs, but mostly we want to ensure it doesn't crash on the message.
    # Since we cannot easily mock RCON.Client (it's a hard dependency in the code),
    # we expect it to fail connection and log error, but NOT crash the process.

    {:ok, pid} = RconConnection.start_link([])
    # The init sends :connect immediately.
    # We wait a bit to let it process.
    Process.sleep(100)
    assert Process.alive?(pid)
  end
end
