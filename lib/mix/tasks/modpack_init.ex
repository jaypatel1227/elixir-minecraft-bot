defmodule Mix.Tasks.Modpack.Init do
  use Mix.Task

  @shortdoc "Generate Docker files for a modpack"

  @moduledoc """
  Generates Dockerfile and docker-compose.yml for a modpack.

  ## Usage

      mix modpack.init <name> [java_version]

  java_version defaults to 17. Common values: 8, 11, 17, 21

  Expects server files to be in server/modpacks/<name>/server/
  """

  def run([name]), do: run([name, "17"])

  def run([name, java_version]) do
    project_root = Mix.Project.deps_path() |> Path.dirname()
    modpack_dir = Path.join([project_root, "server", "modpacks", name])
    server_dir = Path.join(modpack_dir, "server")
    template_dir = Path.join([project_root, "server", "modpacks", "template"])

    unless File.dir?(server_dir) do
      Mix.raise("Server directory not found: #{server_dir}\nExtract your server pack there first.")
    end

    # Generate Dockerfile
    dockerfile_template = Path.join(template_dir, "Dockerfile.eex")
    dockerfile = EEx.eval_file(dockerfile_template, name: name, java_version: java_version)
    File.write!(Path.join(modpack_dir, "Dockerfile"), dockerfile)
    Mix.shell().info("Created #{modpack_dir}/Dockerfile")

    # Copy entrypoint script
    entrypoint_src = Path.join(template_dir, "entrypoint.sh")
    File.copy!(entrypoint_src, Path.join(modpack_dir, "entrypoint.sh"))
    Mix.shell().info("Created #{modpack_dir}/entrypoint.sh")

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
    Mix.raise("Usage: mix modpack.init <name> [java_version]")
  end
end
