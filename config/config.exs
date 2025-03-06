import Config

config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN"),
  gateway_intents: [:guilds, :guild_messages]

# ✅ Ensure Elixir uses tzdata for timezone conversions
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
