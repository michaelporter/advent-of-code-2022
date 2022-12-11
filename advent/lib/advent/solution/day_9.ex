defmodule Advent.Solution.Day9 do

  def part_one do
    moves = get_problem_input()

    %{starting_pos: starting_pos, grid: grid } = build_grid(moves)

    grid = traverse_grid(moves, grid, %{head: starting_pos, tail: starting_pos})

    count = List.flatten(grid)
    |> Enum.filter(fn pos -> pos == "X" end)
    |> length

    { grid, count }
  end

  defp traverse_grid([], grid, current_pos) do
    grid
  end

  defp traverse_grid([{direction, move_count} | moves], grid, current_pos) do
    %{head: {head_x, head_y}, tail: {tail_x, tail_y}} = current_pos

    positions_during_move = %{head: [{head_x, head_y}], tail: [{tail_x, tail_y}]} # this probably gets redundant

    move_count = move_count - 1
    all_positions_hit_during_move = Enum.reduce(0..move_count, positions_during_move, fn step, pdm ->
      latest_head = List.first(pdm[:head])
      latest_tail = List.first(pdm[:tail])
      {latest_head_x, latest_head_y} = latest_head

      case direction do
        :R ->
          new_head = {latest_head_x + 1, latest_head_y}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
        :L ->
          new_head = {latest_head_x - 1, latest_head_y}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
        :U ->
          new_head = {latest_head_x, latest_head_y + 1}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
        :D ->
          new_head = {latest_head_x, latest_head_y - 1}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
        true ->
          IO.puts "bad things have happened"
      end
    end)

    %{ head: head_positions_hit, tail: tail_positions_hit } = all_positions_hit_during_move
    rev_head_pos = Enum.reverse(head_positions_hit)

    grid = tail_positions_hit
    |> Enum.uniq
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.reduce(grid, fn (pos_p, g) ->
      {pos, pos_index} = pos_p

      head_pos = Enum.at(rev_head_pos, pos_index)

      {tail_x, tail_y} = pos
      row = Enum.at(g, tail_y)

      row = List.update_at(row, tail_x, fn val -> "X" end)
      List.update_at(g, tail_y, fn val -> row end)
    end)

    updated_pos = %{
      head: List.first(head_positions_hit),
      tail: List.first(tail_positions_hit)
    }

    traverse_grid(moves, grid, updated_pos)
  end

  defp get_new_tail(latest_tail_pos, new_head_pos) do
    { latest_tail_x, latest_tail_y } = latest_tail_pos
    { new_head_x, new_head_y } = new_head_pos

    differences = Enum.zip_reduce(
      Tuple.to_list(latest_tail_pos),
      Tuple.to_list(new_head_pos),
      [],
      fn t, h, acc ->
        [h - t | acc]
    end) |> Enum.reverse
    differences_abs = Enum.map(differences, fn d -> abs(d) end)

    cond do
      [0, 0] == differences_abs ->
        latest_tail_pos
      Enum.member?([[0, 1], [1, 0], [1, 1]], differences_abs) ->
        latest_tail_pos
      Enum.member?([[2, 1], [1, 2], [2, 2]], differences_abs) ->
        Enum.zip_reduce(Tuple.to_list(latest_tail_pos), differences, [], fn t, d, acc ->
          pos_change = if d > 0, do: 1, else: -1
          [t + pos_change | acc]
        end)
        |> Enum.reverse
        |> List.to_tuple

      Enum.member?([[0, 2], [2, 0]], differences_abs) ->
        Enum.zip_reduce(Tuple.to_list(latest_tail_pos), differences, [], fn t, d, acc ->
          if d == 0 do
            [t | acc]
          else
            pos_change = if d > 0, do: 1, else: -1
            [t + pos_change | acc]
          end
        end)
        |> Enum.reverse
        |> List.to_tuple
      true ->
        IO.puts "nothing matched: #{inspect differences_abs}"
        IO.puts "tail pos: #{inspect Tuple.to_list(latest_tail_pos)}"
        IO.puts "head pos: #{inspect Tuple.to_list(new_head_pos)}"
    end
  end

  defp build_grid(moves, grid_dimensions \\ {200, 200}, current_pos \\ {0,0}, starting_pos \\ {0, 0})

  defp build_grid([], {grid_width, grid_height}, final_pos, starting_pos) do
    IO.puts "width - height: " <> Integer.to_string(grid_width) <> " - " <> Integer.to_string(grid_height)
    %{
      starting_pos: starting_pos,
      grid: Enum.into(0..grid_height, [], fn (_) -> Enum.reduce(0..grid_width, [], fn _, rr -> rr ++ [0] end) end)
    }
  end

  defp build_grid(moves, grid_dimensions, current_pos, starting_pos) do
    [current_move | remaining_moves] = moves
    { grid_width, grid_height } = grid_dimensions
    { pos_x, pos_y } = current_pos
    { starting_x, starting_y } = starting_pos

    case current_move do
      {:R, x_moves} ->
        new_pos_x = pos_x + x_moves
        new_grid_width = if new_pos_x > grid_width, do: new_pos_x, else: grid_width

        build_grid(remaining_moves, {new_grid_width, grid_height}, {new_pos_x, pos_y}, starting_pos)
      {:L, x_moves} ->
        new_pos_x = pos_x - x_moves
        new_grid_width = if new_pos_x < 0, do: grid_width - new_pos_x, else: grid_width
        new_starting_x = if new_pos_x < 0, do: starting_x + new_grid_width - grid_width, else: starting_x
        new_pos_x = if new_pos_x < 0, do: 0, else: new_pos_x

        build_grid(remaining_moves, {new_grid_width, grid_height}, {new_pos_x, pos_y}, {new_starting_x, starting_y})
      {:U, y_moves} ->
        new_pos_y = pos_y + y_moves
        new_grid_height = if new_pos_y > grid_height, do: new_pos_y, else: grid_height

        build_grid(remaining_moves, {grid_width, new_grid_height}, {pos_x, new_pos_y}, starting_pos)
      {:D, y_moves} ->
        new_pos_y = pos_y - y_moves # - 7
        new_grid_height = if new_pos_y < 0, do: grid_height - new_pos_y, else: grid_height
        new_starting_y = if new_pos_y < 0, do: starting_y + new_grid_height - grid_height, else: starting_y
        new_pos_y = if new_pos_y < 0, do: 0, else: new_pos_y

        build_grid(remaining_moves, {grid_width, new_grid_height}, {pos_x, new_pos_y}, {starting_x, new_starting_y})
    end
  end

  ###

  def part_two do

  end

  ###

  defp parse_response_body(body) do
    _ = [:R, :U, :L, :D]
    body
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end) # |> List.to_tuple end)
    |> Enum.map(fn head_instruction ->
      [direction, count] = head_instruction
      {String.to_existing_atom(direction), String.to_integer(count)}
    end)

    # produces a list of tuples, {Direction, Count (as a string)}

  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(9, &parse_response_body/1)
  end
end
