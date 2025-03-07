defmodule Pont.Consumer do
  use Nostrum.Consumer
  @timezone "Asia/Yangon"

  @schedule %{
    [:mon, :thu] => %{channel_id: 1345668774145032224, hour: 18, minute: 45},
    [:tue, :sat] => %{channel_id: 1345668774145032224, hour: 18, minute: 45},
    [:wed, :fri] => %{channel_id: 1345668774145032224, hour: 8, minute: 42}
  }

  @spec handle_event(any()) :: :ok

  def handle_event({:READY, _data, _ws_state}) do
    IO.puts("✅ Bot is ready! Checking schedule...")

    Enum.each(@schedule, fn {days, details} ->
      if today_atom() in days do
        schedule_message_at(details.channel_id, details.hour, details.minute)
      end
    end)
  end

  def handle_event(_event), do: :ok


  defp today_atom do
    {:ok, local_now} = DateTime.now(@timezone)
    local_now
    |> Date.day_of_week()
    |> day_number_to_atom()
  end

  defp day_number_to_atom(1), do: :mon
  defp day_number_to_atom(2), do: :tue
  defp day_number_to_atom(3), do: :wed
  defp day_number_to_atom(4), do: :thu
  defp day_number_to_atom(5), do: :fri
  defp day_number_to_atom(6), do: :sat
  defp day_number_to_atom(7), do: :sun

  defp schedule_message_at(channel_id, hour, minute) do
    {:ok, local_now} = DateTime.now(@timezone)

    case NaiveDateTime.new(local_now.year, local_now.month, local_now.day, hour, minute, 0) do
      {:ok, naive_target_time} ->
        {:ok, today_target_time} = DateTime.from_naive(naive_target_time, @timezone)

        delay =
          if DateTime.compare(local_now, today_target_time) == :lt do
            DateTime.diff(today_target_time, local_now, :millisecond)
          else
            # If time has passed today, schedule for the same day next week
            next_week_target_time = DateTime.add(today_target_time, 7 * 86_400, :second)
            DateTime.diff(next_week_target_time, local_now, :millisecond)
          end

        IO.puts("⏳ Scheduling message for #{channel_id} in #{div(delay, 1000)} seconds at #{hour}:#{minute} #{@timezone}")

        Task.start(fn ->
          Process.sleep(delay)  # Wait until the scheduled time
          message = "@everyone Now it's #{hour}:#{minute} meeting will be start at 7PM "
          send_message(channel_id, message)
        end)

      {:error, reason} ->
        IO.puts("❌ Failed to create target NaiveDateTime: #{inspect(reason)}")
    end
  end

  defp send_message(channel_id, content) do
    case Nostrum.Api.Message.create(channel_id, content) do
      {:ok, _msg} -> IO.puts("✅ Message sent successfully to #{channel_id}: #{content}")
      {:error, reason} -> IO.puts("❌ Failed to send message: #{inspect(reason)}")
    end
  end
end
