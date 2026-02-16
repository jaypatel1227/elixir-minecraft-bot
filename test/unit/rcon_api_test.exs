defmodule RconApiTest do
  use ExUnit.Case

  alias ElixirMinecraftBot.Rcon.RconAPI
  alias ElixirMinecraftBot.Rcon.RconConnection

  setup do
    test_pid = self()
    pid = spawn(fn -> loop(test_pid) end)
    Process.register(pid, RconConnection)
    on_exit(fn ->
      if Process.alive?(pid), do: Process.exit(pid, :kill)
    end)
    :ok
  end

  defp loop(test_pid) do
    receive do
      {:"$gen_call", from, {:cmd, cmd}} ->
        send(test_pid, {:received_cmd, cmd})
        GenServer.reply(from, {:ok, "Mock response for #{cmd}"})
        loop(test_pid)
      _ ->
        loop(test_pid)
    end
  end

  test "ban_user sends correct command" do
    assert {:ok, _} = RconAPI.ban_user("TestUser")
    assert_received_command("ban TestUser")

    assert {:ok, _} = RconAPI.ban_user("TestUser", "Reason")
    assert_received_command("ban TestUser Reason")
  end

  test "kick_user sends correct command" do
    assert {:ok, _} = RconAPI.kick_user("TestUser")
    assert_received_command("kick TestUser")

    assert {:ok, _} = RconAPI.kick_user("TestUser", "Reason")
    assert_received_command("kick TestUser Reason")
  end

  defp assert_received_command(expected_cmd) do
    assert_receive {:received_cmd, ^expected_cmd}, 1000
  end
end
