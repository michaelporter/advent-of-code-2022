defmodule Advent.Solution.Day5 do

  # which crate will end up on top of each stack at the end of the process
  def part_one do
    {stacks, moves} = get_problem_input

    move_stacks(moves, stacks)
    |> Enum.map(fn stack -> List.first(stack) end)
    |> Enum.join("")
  end

  defp move_stacks([current_move | future_moves], stacks) do
    %{from: from, move: count, to: to} = current_move
    from_stack = Enum.at(stacks, from - 1)
    to_stack = Enum.at(stacks, to - 1)

    { moving_items, new_from_stack } = Enum.split(from_stack, count)
    new_to_stack = Enum.reverse(moving_items) ++ to_stack

    updated_stacks = stacks |> List.replace_at(to - 1, new_to_stack) |> List.replace_at(from - 1, new_from_stack)

    move_stacks(future_moves, updated_stacks)
  end

  defp move_stacks([], stacks) do # recursion end state
    stacks
  end

  ###

  def part_two do

  end

  ###

  defp parse_input_halves(input_halves) do
    [stacks, moves] = input_halves
    parsed_moves = parse_moves(moves) # [{from: 1, move: 2, to: 6}, ...]
    parsed_stacks = parse_stacks(stacks) # [["V", "F"], [], ["C", "H", "Y"], ...], 9 total indexes

    {parsed_stacks, parsed_moves}
  end

  defp parse_moves(moves) do
    moves |> String.split("\n", trim: true)
    |> Enum.map(fn move -> String.split(move, " ") end)
    |> Enum.map(fn move -> Enum.chunk_every(move, 2) end)
    |> Enum.map(fn ci ->
      Enum.into(ci, %{}, fn cii ->
        [k, v] = cii
        {String.to_atom(k), String.to_integer(v)}
      end)
    end)
  end

  defp parse_stacks(stacks) do
    # produces an ordered list of stacks, 1 - 9 (0-8 indexes)
    # with the letters in top-to-bottom direction

    #[
      # ["V", "R", "H", "B", "G", "D", "W"],
      # ["F", "R", "C", "G", "N", "J"],
      # ["J", "N", "D", "H", "F", "S", "L"],
      # ["V", "S", "D", "J"],
      # ["V", "N", "W", "Q", "R", "D", "H", "S"],
      # ["M", "C", "H", "G", "P"],
      # ["C", "H", "Z", "L", "G", "B", "J", "F"],
      # ["R", "J", "S"],
      # ["M", "V", "N", "B", "R", "S", "G", "L"]
    # ]

    String.split(stacks, "\n") |> Enum.map(fn stack -> String.split(stack, "") end) |> Enum.zip |> Enum.map(fn tup -> Tuple.to_list(tup) end) |> Enum.map(fn l -> Enum.filter(l, fn li -> Regex.match?(~r/[[:alpha:]]/, li) end) end) |> Enum.filter(fn l -> !Enum.empty?(l) end)
  end

  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split(~r/\d \n\n/, trim: true)
    |> parse_input_halves
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(5, &parse_response_body/1)
  end
end
