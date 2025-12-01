defmodule ElixirMinecraftBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    rcon_worker = if Application.get_env(:elixir_minecraft_bot, :start_rcon, true) do
      [ElixirMinecraftBot.Rcon.RconConnection]
    else
      []
    end

    children = rcon_worker

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMinecraftBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
