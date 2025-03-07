import Config

config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN"),
  gateway_intents: [:guilds, :guild_messages]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
