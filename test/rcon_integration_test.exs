defmodule RconIntegrationTest do
  use ExUnit.Case

  alias ElixirMinecraftBot.Rcon.RconAPI

  @moduletag :integration

  test "get server status" do
    result = case RconAPI.get_status() do
      {:error, _} ->
        Process.sleep(100)
        RconAPI.get_status()
      ok -> ok
    end
    assert {:ok, response} = result
    assert is_binary(response)
  end

  test "whitelist user" do
    assert {:ok, response} = RconAPI.whitelist_user("TestPlayer")
    assert is_binary(response)
  end

  test "op user" do
    assert {:ok, response} = RconAPI.op_user("Turblo")
    assert is_binary(response)
  end

  test "run arbitrary command" do
    assert {:ok, response} = RconAPI.run_command("seed")
    assert is_binary(response)
  end

  test "set time to day" do
    assert {:ok, response} = RconAPI.set_time_day()
    assert response =~ "Set the time to"
  end

  test "say broadcasts message" do
    assert {:ok, _} = RconAPI.say("Test broadcast")
  end

  test "weather clear" do
    assert {:ok, response} = RconAPI.weather("clear")
    assert is_binary(response)
  end

  test "weather rain" do
    assert {:ok, response} = RconAPI.weather("rain")
    assert is_binary(response)
  end
end
