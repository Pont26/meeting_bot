defmodule Pont.Application do
  use Application

  def start(_type, _args) do
    children = [
      Pont.Consumer  # Starts the Consumer module (listens for messages)
    ]

    opts = [strategy: :one_for_one, name: Pont.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

#This is reponsible for strting the bot, it act like the main controller
#when the bot start this file run first
#and start Pont.consumer which listens to discord events.
