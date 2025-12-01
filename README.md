# ElixirMinecraftBot

A Discord bot for managing Minecraft servers via RCON. This bot allows server administrators to execute common Minecraft server commands directly from Discord.

## Features

- **RCON Integration**: Connect to your Minecraft server using RCON protocol
- **Discord Commands**: Execute server commands through Discord messages
- **Server Status**: Check who's online with `!status`
- **Whitelist Management**: Add players to the whitelist with `!whitelist <username>`
- **Operator Management**: Grant operator permissions with `!op <username>`
- **Automatic Reconnection**: Handles RCON connection failures with automatic retry

## Prerequisites

- Elixir 1.19 or higher
- A Minecraft server with RCON enabled
- A Discord bot token

## Configuration

1. Copy the example environment file:
   ```bash
   cp config/.env.exs.example config/.env.exs
   ```

2. Edit `config/.env.exs` with your credentials:
   ```elixir
   import Config

   config :nostrum,
     token: "YOUR_DISCORD_BOT_TOKEN"

   config :rcon,
     host: "YOUR_MINECRAFT_SERVER_HOST",
     port: 25575,
     password: "YOUR_RCON_PASSWORD"
   ```

## Installation

1. Install dependencies:
   ```bash
   mix deps.get
   ```

2. Run the bot:
   ```bash
   mix run --no-halt
   ```

## Discord Commands

- `!status` - Shows the list of players currently online
- `!whitelist <username>` - Adds a player to the server whitelist
- `!op <username>` - Grants operator permissions to a player

## Architecture

- **Application**: Supervises the RCON connection
- **RconConnection**: GenServer managing persistent RCON connection with auto-reconnect
- **RconAPI**: High-level API for executing Minecraft commands
- **Bot.Consumer**: Handles Discord events and processes commands

## Logging

The bot logs extensive information to help with debugging:
- RCON connection attempts and status
- Command execution and responses
- Discord message processing
- Error conditions and reconnection attempts

