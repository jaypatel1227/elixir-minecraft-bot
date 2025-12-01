import Config

if File.exists?("config/.env.exs") do
  import_config ".env.exs"
end

if Mix.env() == :test do
  import_config "test.exs"
end
