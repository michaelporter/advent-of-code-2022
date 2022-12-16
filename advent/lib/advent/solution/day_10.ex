defmodule Advent.Solution.Day10 do

  def part_one do
    %{ history: history } = get_problem_input()
    |> Enum.reduce(%{last: {"noop", 0}, history: []}, fn (cmd, ticker) ->
      {action, _} = cmd
      %{last: {_, last_val}, history: history} = ticker

      history = update_history(history, action, last_val)

      %{
        last: cmd,
        history: history
      }
    end)

    results = history |> Enum.reverse

    [20, 60, 100, 140, 180, 220]
    |> Enum.map(fn i -> i * Enum.at(results, i - 1) end)
    |> Enum.sum
  end

  defp update_history(history, action, last_val) do
    last_x = if length(history) == 0, do: 1, else: Enum.at(history, 0)
    current_x_value = last_val + last_x

    case action do
      "noop" ->
        new_history = [current_x_value]
        List.flatten([new_history | history])

      "addx" ->
        new_history = [current_x_value, current_x_value]
        List.flatten([new_history | history])
      _ -> history
    end
  end

  ###

  # the CRT draws a single pixel per cycle.
  # the pixel's on/off state is determined by whether the cursor overlaps with it
  # when the CRT is going over it
  #
  # the cursor is 3 pixels wide, and the X value determines where the center one is
  #
  # "#" is lit, "." is off
  #
  # the CRT is 40 x 6 lines

  def part_two do
    %{ history: history } = get_problem_input()
    |> Enum.reduce(%{last: {"noop", 0}, history: []}, fn (cmd, ticker) ->
      {action, _} = cmd
      %{last: {_, last_val}, history: history} = ticker

      history = update_history(history, action, last_val)

      %{
        last: cmd,
        history: history
      }
    end)

    results = history |> Enum.reverse

    screen = Enum.into(0..5, [], fn _ -> Enum.into(0..39, [], fn _ -> "." end) end)

    history
    # |> Enum.take(240)
    |> Enum.with_index
    |> Enum.reduce(screen, fn ({x_value, index}, s) ->

      cursor_position = x_value
      crt_position = index

      IO.puts "cursor, x val = #{x_value}"
      cursor_row_index = get_value_row(x_value - 1)
      cursor_col_index = x_value - 40 * cursor_row_index
      cursor_col_index = if cursor_col_index < 0, do: 39 + cursor_col_index, else: cursor_col_index

      IO.puts "#{cursor_row_index}, #{cursor_col_index}"

      IO.puts "screen, index: #{index}"
      crt_row_index = get_value_row(index)
      crt_col_index = index - 40 * crt_row_index

      crt_col_index = if crt_col_index < 0, do: 39 + crt_col_index, else: crt_col_index
      IO.puts "#{crt_row_index}, #{crt_col_index}"

      # overlap = cursor_row_index == crt_row_index && abs(crt_col_index - cursor_row_index) < 3

      # this is close, but the cursor never goes out of Row 1, which seems odd
      overlap = abs(crt_col_index - cursor_row_index) < 3

      if overlap do
        IO.puts "Overlap!"
        IO.puts "Cursor: #{cursor_row_index}, #{cursor_col_index}"
        IO.puts "CRT: #{crt_row_index}, #{crt_col_index}"
        row_to_update = Enum.at(screen, crt_row_index)
        IO.puts inspect row_to_update
        updated_row = List.update_at(row_to_update, crt_col_index, fn _ -> "#" end)
        IO.puts inspect updated_row
        s = List.update_at(s, crt_row_index, fn _ -> updated_row end)
        IO.puts inspect s
        s
      else
        s
      end
    end)

  end

  defp get_value_row(index) do
    cond do
      index < 40 -> 0
      index > 39 && index < 80 -> 1
      index > 79 && index < 120 -> 2
      index > 119 && index < 160 -> 3
      index > 159 && index < 200 -> 4
      index > 199 && index < 240 -> 5
    end
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
    # Advent.InputFetcher.fetch_for_day(10, &parse_response_body/1)
    "noop
    noop
    noop
    addx 6
    addx -1
    addx 5
    noop
    noop
    noop
    addx 5
    addx 11
    addx -10
    addx 4
    noop
    addx 5
    noop
    noop
    noop
    addx 1
    noop
    addx 4
    addx 5
    noop
    noop
    noop
    addx -35
    addx -2
    addx 5
    addx 2
    addx 3
    addx -2
    addx 2
    addx 5
    addx 2
    addx 3
    addx -2
    addx 2
    addx 5
    addx 2
    addx 3
    addx -28
    addx 28
    addx 5
    addx 2
    addx -9
    addx 10
    addx -38
    noop
    addx 3
    addx 2
    addx 7
    noop
    noop
    addx -9
    addx 10
    addx 4
    addx 2
    addx 3
    noop
    noop
    addx -2
    addx 7
    noop
    noop
    noop
    addx 3
    addx 5
    addx 2
    noop
    noop
    noop
    addx -35
    noop
    noop
    noop
    addx 5
    addx 2
    noop
    addx 3
    noop
    noop
    noop
    addx 5
    addx 3
    addx -2
    addx 2
    addx 5
    addx 2
    addx -25
    noop
    addx 30
    noop
    addx 1
    noop
    addx 2
    noop
    addx 3
    addx -38
    noop
    addx 7
    addx -2
    addx 5
    addx 2
    addx -8
    addx 13
    addx -2
    noop
    addx 3
    addx 2
    addx 5
    addx 2
    addx -15
    noop
    addx 20
    addx 3
    noop
    addx 2
    addx -4
    addx 5
    addx -38
    addx 8
    noop
    noop
    noop
    noop
    noop
    noop
    addx 2
    addx 17
    addx -10
    addx 3
    noop
    addx 2
    addx 1
    addx -16
    addx 19
    addx 2
    noop
    addx 2
    addx 5
    addx 2
    noop
    noop
    noop
    noop
    noop
    noop" |> parse_response_body
  end
end
