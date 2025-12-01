defmodule ElixirMinecraftBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting ElixirMinecraftBot application")

    children = [
      ElixirMinecraftBot.Rcon.RconConnection,
      ElixirMinecraftBot.Bot.Consumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMinecraftBot.Supervisor]

    case Supervisor.start_link(children, opts) do
      {:ok, pid} ->
        Logger.info("ElixirMinecraftBot supervisor started successfully with PID: #{inspect(pid)}")
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start ElixirMinecraftBot supervisor: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
