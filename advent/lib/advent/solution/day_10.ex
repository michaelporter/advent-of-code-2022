defmodule Advent.Solution.Day10 do

  # trying to replace the video output of my device
  # CRT driven by a clock circle, ticks measured as "a cycle"
  #
  # first goal: figure out the signal being sent by the CPU
  # - the CPU had a single register, "X", which starts with the value 1
  #   and supports 2 instructions:
  #     "addx V" consumes 2 cycles; after 2 cycles, the X reg is increased by the value of V
  #       (V can also be negative)
  #     "noop", consumes 1 cycle and has no effect
  #
  # "signal strength" is the cycle number * the value of the X reg at that cycle
  # - note: "during" the cycle, so if you're on the second cycle of a "addx V", the value is still without the V
  #
  # part one goal: find the signal strength during the 20th cycle, and
  # then during every 40th cycle after that (60, 100, 140, 180, 220)
  # ending during the 220 cycle
  #
  # the value of part_one is the sum of these values

  defp get_starting_from_last(last) do
    case last do
      {} -> {"noop", nil}
      {cmd, val} -> last
    end
  end

  def part_one do
    %{ history: history } = get_problem_input
    |> Enum.reduce(%{last: {"noop", 0}, history: []}, fn (cmd, ticker) ->
      {action, value} = cmd
      %{last: {last_cmd, last_val}, history: history} = ticker

      last_x = if length(history) == 0, do: 1, else: Enum.at(history, 0)
      to_append = []

      to_append = if action == "noop", do: [last_val + last_x], else: to_append
      to_append = if action == "addx", do: [last_val + last_x, last_val + last_x], else: to_append

      history = List.flatten([to_append | history])

      %{
        last: cmd,
        history: history
      }
    end)

    # %{ history: history } = results
    results = history |> Enum.reverse

    # lol
    Enum.sum([
      20 * Enum.at(results, 19),
      60 * Enum.at(results, 59),
      100 * Enum.at(results, 99),
      140 * Enum.at(results, 139),
      180 * Enum.at(results, 179),
      220 * Enum.at(results, 219)
    ])
  end

  ###

  def part_two do

  end

  ###

  defp parse_response_body(body) do
    String.trim_trailing(body)
    |> String.split("\n", trim: true)
    |> Enum.map(fn cmd -> String.split(cmd, " ", trim: true) end)
    |> Enum.map(fn cmd ->
      cmd = if length(cmd) == 2, do: [Enum.at(cmd, 0), String.to_integer(Enum.at(cmd, 1))], else: [Enum.at(cmd, 0), 0]
      List.to_tuple(cmd)
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(10, &parse_response_body/1)
  end
end
