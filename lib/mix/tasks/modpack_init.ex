defmodule Mix.Tasks.Modpack.Init do
  use Mix.Task

  @shortdoc "Generate Docker files for a modpack"

  @moduledoc """
  Generates Dockerfile and docker-compose.yml for a modpack.

  ## Usage

      mix modpack.init <name>

  Expects server files to be in server/modpacks/<name>/server/
  """

  def run([name]) do
    modpack_dir = Path.join(["server", "modpacks", name])
    server_dir = Path.join(modpack_dir, "server")
    template_dir = Path.join(["server", "modpacks", "template"])

    unless File.dir?(server_dir) do
      Mix.raise("Server directory not found: #{server_dir}\nExtract your server pack there first.")
    end

    # Generate Dockerfile
    dockerfile_template = Path.join(template_dir, "Dockerfile.eex")
    dockerfile = EEx.eval_file(dockerfile_template, name: name)
    File.write!(Path.join(modpack_dir, "Dockerfile"), dockerfile)
    Mix.shell().info("Created #{modpack_dir}/Dockerfile")

    # Generate docker-compose.yml
    compose_template = Path.join(template_dir, "docker-compose.yml.eex")
    compose = EEx.eval_file(compose_template, name: name)
    File.write!(Path.join(modpack_dir, "docker-compose.yml"), compose)
    Mix.shell().info("Created #{modpack_dir}/docker-compose.yml")

    Mix.shell().info("""

    Done! To start the server:

        docker compose -f docker-compose.yml -f #{modpack_dir}/docker-compose.yml up -d --build
    """)
  end

  def run(_) do
    Mix.raise("Usage: mix modpack.init <name>")
  end
end
