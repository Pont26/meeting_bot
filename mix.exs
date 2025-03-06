defmodule Pont.MixProject do
  use Mix.Project

  def project do
    [
      app: :pont,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Pont.Application, []}  # ✅ This tells Elixir to start the Pont application
    ]
  end

  defp deps do
    [
      {:tzdata, "~> 1.1"},
      {:nostrum, "~> 0.10"}  # ✅ Nostrum dependency for Discord bot
    ]
  end
end
