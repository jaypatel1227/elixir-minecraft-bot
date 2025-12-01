defmodule ElixirMinecraftBot.Rcon.RconConnection do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def send_command(command) do
    GenServer.call(__MODULE__, {:cmd, command})
  end

  @impl true
  def init(_) do
    send(self(), :connect)
  end

  @impl true
  def handle_server_info(:connect, state) do
    host = Application.get_env(:rcon, :host)
    port = Application.get_env(:rcon, :port)
    password = Application.get_env(:rcon, :password)

    Logger.info("Connecting to the RCON server at host: #{host}")

    with {:ok, conn} <- RCON.Client.connect(host, port),
         {:ok, conn, _} <- RCON.Client.authenticate(conn, password) do
      Logger.info("Successfully connected to the RCON server")
      {:noreply, %{state | conn: conn}}
    else
      err ->
        Logger.error("Failed to connect to the RCON Server: #{inspect(err)}")
        # Not trying exponential backoff here. Just keep trying I guess
        Process.send_after(self(), :connect, 5_000)
        {:noreply, %{state | conn: nil}}
    end
  end

  @impl true
  def handle_call({:cmd, _cmd}, _from, %{conn: nil} = state) do
    {:reply, {:error, :not_connected}, state}
  end

  def handle_call({:cmd, cmd}, _from, %{conn: conn} = state) do
    # RCON.Client.exec returns {:ok, new_conn, response}
    case RCON.Client.exec(conn, cmd) do
      {:ok, new_conn, response} ->
        {:reply, {:ok, response}, %{state | conn: new_conn}}

      {:error, reason} ->
        # If the command fails, force a reconnect
        send(self(), :connect)
        {:reply, {:error, reason}, %{state | conn: nil}}
    end
  end
end
