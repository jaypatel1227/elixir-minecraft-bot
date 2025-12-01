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
| `MAX_MEMORY` | No | Minecraft server memory (default: `4G`, Docker only) |

## Docker Deployment

Start vanilla server + bot:

```bash
docker compose up -d
```

### Running with Modpacks

1. Download your modpack's server files (usually a zip)

2. Extract to `server/modpacks/<name>/server/`:
   ```bash
   mkdir -p server/modpacks/my-modpack/server
   unzip ServerPack.zip -d server/modpacks/my-modpack/server/
   ```

3. Check `variables.txt` for the required Java version:
   - Minecraft 1.16 and below: Java 8
   - Minecraft 1.17: Java 16
   - Minecraft 1.18-1.20: Java 17
   - Minecraft 1.21+: Java 21

4. Generate Docker files:
   ```bash
   mix modpack.init <name> [java_version]
   # Example: mix modpack.init my-modpack 17
   ```

5. Start the server and bot:
   ```bash
   docker compose -f docker-compose.yml -f server/modpacks/<name>/docker-compose.yml up -d --build
   ```

The generated Docker setup will:
- Auto-accept Mojang's EULA
- Skip Java version checks (uses the image's Java)
- Enable RCON with password from `RCON_PASSWORD` env var
- Enable whitelist and enforce-whitelist

First startup may take several minutes as Forge/Fabric downloads and installs.

### Modpack Directory Structure

```
server/modpacks/
├── template/           # Templates (don't edit unless customizing)
│   ├── Dockerfile.eex
│   ├── docker-compose.yml.eex
│   └── entrypoint.sh
└── my-modpack/         # Your modpack
    ├── Dockerfile      # Generated
    ├── docker-compose.yml  # Generated
    ├── entrypoint.sh   # Generated
    └── server/         # Extracted server files
        ├── mods/
        ├── config/
        ├── start.sh
        ├── variables.txt
        └── ...
```

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
