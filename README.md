# ElixirMinecraftBot

A Discord bot for managing Minecraft servers via RCON.

## Prerequisites

- Elixir 1.19+ (for local development)
- Docker and Docker Compose (for containerized deployment)
- A Discord bot token

## Discord Commands

| Command | Description |
|---------|-------------|
| `!status` | Shows players currently online |
| `!whitelist <user>` | Add player to whitelist |
| `!op <user>` | Grant operator permissions |
| `!tp <player> <dest>` | Teleport a player |
| `!day` | Set time to day |
| `!say <message>` | Broadcast message to server |
| `!whisper <player> <msg>` | Private message a player |
| `!weather <clear\|rain\|thunder>` | Change weather |
| `!restart` | Restart the server |
| `!stop` | Stop the server |
| `!start` | Start the server |
| `!backup` | Create world backup |

## Configuration

Copy `.env.example` to `.env` and set your values:

```bash
cp .env.example .env
```

| Variable | Required | Description |
|----------|----------|-------------|
| `DISCORD_TOKEN` | Yes | Your Discord bot token |
| `RCON_PASSWORD` | Yes | RCON password (must match server) |
| `RCON_HOST` | No | RCON server host (default: `localhost`) |
| `RCON_PORT` | No | RCON server port (default: `25575`) |
| `MAX_MEMORY` | No | Minecraft server memory (default: `8G`, Docker only) |

## Docker Deployment

Start vanilla server + bot:

```bash
docker compose up -d
```

### Running with Modpacks

1. Extract server pack to `server/modpacks/<name>/server/`
2. Generate Docker files: `mix modpack.init <name>`
3. Start: `docker compose -f docker-compose.yml -f server/modpacks/<name>/docker-compose.yml up -d --build`

## Local Development

```bash
source .env  # or use direnv
mix deps.get
mix run --no-halt
```

## Testing

Unit tests (no server required):

```bash
mix test
```

Integration tests require a running Minecraft server with RCON:

```bash
cp config/test.exs.example config/test.exs
# Edit config/test.exs with your RCON password
mix test --include integration
```
