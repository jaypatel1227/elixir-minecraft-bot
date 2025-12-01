defmodule ElixirMinecraftBotTest do
  use ExUnit.Case
  doctest ElixirMinecraftBot

  test "greets the world" do
    assert ElixirMinecraftBot.hello() == :world
  end

  test "get the status the server" do
    assert ElixirMinecraftBot.Bot.Consumer.handle_event(
             {:MESSAGE_CREATE, %{content: "!status", channel_id: 1, author: %{bot: false}}, nil}
           )
  end

  test "make Turblo an operator" do
    assert ElixirMinecraftBot.Bot.Consumer.handle_event(
             {:MESSAGE_CREATE, %{content: "!op Turblo", channel_id: 1, author: %{bot: false}},
              nil}
           )
  end
end
