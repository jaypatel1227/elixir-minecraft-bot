defmodule ElixirMinecraftBotTest do
  use ExUnit.Case
  doctest ElixirMinecraftBot

  test "greets the world" do
    assert ElixirMinecraftBot.hello() == :world
  end
end
