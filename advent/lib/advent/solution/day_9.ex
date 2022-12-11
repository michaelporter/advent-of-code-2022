defmodule Advent.Solution.Day9 do

  # H and T must always be touching in some direction, NEWS or diagonal (NE SE SW NW)
  #
  # if the head is ever 2 steps direction NEWS, the tail must move one step that direction
  #
  # and if the H and T are not in the same row or column (H has moved diagonally in all these cases?),
  # then the T moves diagonally one space to keep up
  #
  # the Input is a set of instructions for the Head, R, U, L, D (Right, Up, Left, Down) and the number of steps it moves
  # - after each of the steps PER MOVE, the T updates. So the H doesn't get like 4 steps ahead and then T moves, T moves continuously)
  #
  # if, after a move, the H is no longer adjacent to the T, then the T must move to get closer
  #
  # also note, the H can be on the same square as the T.
  #
  # After all the moves, we'll know which positions the T was in
  #
  # Solution asks: HOW MANY DIFFERENT POSITONS WAS THE T IN?


  def part_one do
    moves = get_problem_input()

    # create the grid based on the directions?
    # then can use a copy of the grid to represent where T has been

    # width - height: 353 - 232
    #%{starting_pos: starting_pos, grid: grid } = #build_grid(moves)
    %{starting_pos: starting_pos, grid: grid } = %{
      starting_pos: {18, 18},
      grid: Enum.into(0..300, [], fn (_) -> Enum.reduce(0..400, [], fn _, rr -> rr ++ [0] end) end)
    }

    IO.puts "Starting Pos: #{inspect starting_pos}"

    grid = traverse_grid(moves, grid, %{head: starting_pos, tail: starting_pos})
    # |> count_visited_pos

    # Enum.each(grid, fn row -> IO.puts(inspect(row)) end)

    count = List.flatten(grid)
    |> Enum.filter(fn pos -> pos == "X" end)
    |> length

    # "test"

    { grid, count }
  end

  # defp traverse_grid(moves, grid, current_pos \\ %{head: {0,0}, tail: {0,0}})

  defp traverse_grid([], grid, current_pos) do
    grid
  end

  defp traverse_grid([{direction, move_count} | moves], grid, current_pos) do
    %{head: {head_x, head_y}, tail: {tail_x, tail_y}} = current_pos
    IO.puts "CURRENT POS: #{inspect current_pos}"

    positions_during_move = %{head: [{head_x, head_y}], tail: [{tail_x, tail_y}]} # this probably gets redundant

    move_count = move_count - 1
    all_positions_hit_during_move = Enum.reduce(0..move_count, positions_during_move, fn step, pdm ->
      IO.puts "---"
      # IO.puts inspect step
      # IO.puts inspect pdm
      # IO.puts inspect pdm[:head]

      latest_head = List.first(pdm[:head])
      latest_tail = List.first(pdm[:tail])

      IO.puts "head: #{inspect latest_head}"
      IO.puts "tail: #{inspect latest_tail}"

      IO.puts "----"
      {latest_head_x, latest_head_y} = latest_head
      IO.puts inspect latest_head

      case direction do
        :R ->
          new_head = {latest_head_x + 1, latest_head_y}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
        :L ->
          new_head = {latest_head_x - 1, latest_head_y}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
          # i dunno
        :U ->
          new_head = {latest_head_x, latest_head_y + 1}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
          # hey
        :D ->
          new_head = {latest_head_x, latest_head_y - 1}
          new_tail = get_new_tail(latest_tail, new_head)
          %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
          # hey
        true ->
          IO.puts "bad things have happened"
      end
      # update the accumulator
      # %{head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]]}
    end)

    %{ head: head_positions_hit, tail: tail_positions_hit } = all_positions_hit_during_move
    rev_head_pos = Enum.reverse(head_positions_hit)

    grid = Enum.reduce(Enum.with_index(Enum.reverse(Enum.uniq(tail_positions_hit))), grid, fn (pos_p, g) ->
      {pos, pos_index} = pos_p

      head_pos = Enum.at(rev_head_pos, pos_index)

      # IO.puts "\n\n"
      # IO.puts "Direction: #{inspect direction} #{inspect move_count}"
      # IO.puts "Starting POS: #{inspect current_pos} "
      # IO.puts "Current Step POS HEAD: #{inspect head_pos }"
      # IO.puts "Current Step POS TAIL: #{inspect pos }"
      # IO.puts "\n\n"

      # IO.gets "press any key when ready"


      {tail_x, tail_y} = pos
      row = Enum.at(g, tail_y)

      # row =
      IO.puts "attempting update: at #{tail_x}, #{tail_y} - #{inspect row}"
      row = List.update_at(row, tail_x, fn val -> "X" end)
      g = List.update_at(g, tail_y, fn val -> row end)

      g
    end)

    updated_pos = %{
      head: List.first(head_positions_hit),
      tail: List.first(tail_positions_hit)
    }



    # grid
    traverse_grid(moves, grid, updated_pos)
  end

  defp get_new_tail(latest_tail_pos, new_head_pos) do
    # adjacent_pos = [
    #   { latest_tail_x, latest_tail_y + 1 } # N
    #   { latest_tail_x + 1, latest_tail_y + 1 } # NE
    #   { latest_tail_x + 1, latest_tail_y }# E
    #   { latest_tail_x + 1, latest_tail_y - 1 }# SE
    #   { latest_tail_x, latest_tail_y - 1 } # S
    #   { latest_tail_x - 1, latest_tail_y - 1 } # SW
    #   { latest_tail_x - 1, latest_tail_y } # W
    #   { latest_tail_x - 1, latest_tail_y + 1 # NW
    # ]

    { latest_tail_x, latest_tail_y } = latest_tail_pos
    { new_head_x, new_head_y } = new_head_pos

    IO.puts "latest tail: #{inspect latest_tail_pos}"
    IO.puts "new head: #{inspect new_head_pos}"

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
        # do nothing, same pos
        # return the same T pos value, I guess
        latest_tail_pos
      Enum.member?([[0, 1], [1, 0], [1, 1]], differences_abs) ->
        # do nothing, this is adjancecy
        # return the same T pos value, I guess
        latest_tail_pos
      Enum.member?([[2, 1], [1, 2], [2, 2]], differences_abs) ->
        # this is the diagonal case
        # change both coords by 1, using the unary that reflects the relationship with H coords
        # return the updated tail

        Enum.zip_reduce(Tuple.to_list(latest_tail_pos), differences, [], fn t, d, acc ->
          pos_change = if d > 0, do: 1, else: -1
          [t + pos_change | acc]
        end)
        |> Enum.reverse
        |> List.to_tuple

      Enum.member?([[0, 2], [2, 0]], differences_abs) ->
        # this is the linear gap distance, add or subtract 1 to the coord that is off by 2
        # return the updated tail value

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
    # get the diff between the H pos and the T pos, then:

    # for 0 distance
      # abs value of (0, 0)
    # do nothing

    # for distance of 1 for either or both, this is ADJACENCY
    #  - abs values of (0, 1), (1, 0), (1, 1)
    # do nothing

    # for distance of 2 in either x or y,
    # if neither x nor y is shared, then do the diagonal case (one with be 2, the other will be 1 off)
        # abs values of (2, 1), (1, 2)  // (2, 1), (-2, 1), (-2, -1), (1, 2), (-1, 2), (-1, -2)
        # for the diagonal case,
        # maybe what I need to do is grab the NEWS adjacent squares of the H pos
        # and then see which one can be reached by changing both values of T pos
        # or rather, where T pos differs from the adjacent pos by 1 for both x and y
        #
        # or maybe, I think I can do a simple change of 1 for both x and y, using the unary sign
        # of the difference between T and H. So a distance of -2, 1 says I change T x by -1 and y by +1

    # if one of x or y is shared, increment that one by 1
      # abs values of (0, 2), (2, 0)



    # same_pos = [
    #   {latest_tail_x, latest_tail_y} # don't forget to handle this case
    # ]

    # diagonally_separate = latest_tail_x != new_head_x && latest_tail_y != new_head_y

    #
    # for the case where H has moved along NEWS to be 2 away from T
    #
    # x_axis_separated = abs(new_head_x - latest_tail_x) == 2
    # y_axis_separated = abs(new_head_x - latest_tail_x) == 2

    # new_tail_x = if x_axis_separated, do: latest_tail_x + (new_head_x - latest_tail_x) / 2, else: latest_tail_x
    # new_tail_y = if y_axis_separated, do: latest_tail_y + (new_head_y - latest_tail_y) / 2, else: latest_tail_y
    #

    # when H shares neither X nor Y, T must move diagonally. That is, must
    # move so that it is straight U, D, R, L. Not a diagonal positiioning

    # detatched_pos = [
    #   { latest_tail_x - 1, latest_tail_y + 2 } # NNW -> x - 1, y + 1
    #   { latest_tail_x, latest_tail_y + 2 } # NN -> x + 0, y + 1
    #   { latest_tail_x + 1, latest_tail_y + 2 } # NNE -> x + 1, y + 1

    #   { latest_tail_x + 2, latest_tail_y + 1} # ENE -> x + 1, y + 1
    #   { latest_tail_x + 2, latest_tail_y } # E -> x + 1, y + 0
    #   { latest_tail_x + 2, latest_tail_y - 1 }# ESE -> x + 1, y - 1

    #   { latest_tail_x + 1, latest_tail_y - 2 } # SSE -> x + 1, y - 1
    #   { latest_tail_x, latest_tail_y - 2 } # S -> x + 0,  y - 1
    #   { latest_tail_x - 1, latest_tail_y - 2 } # SSW -> x - 1, y - 1

    #   { latest_tail_x - 2, latest_tail_y - 1} # WSW -> x - 1, y - 1
    #   { latest_tail_x - 2, latest_tail_y } # WW -> x - 1, y + 0
    #   { latest_tail_x - 2, latest_tail_y + 1 # WNW -> x - 1, y + 1
    # ]

    # is_adjacent = Enum.contains?(adjacent_pos, {new_head_x, new_head_y})

    # if is_adjacent do
    #   { latest_tail_x, latest_tail_y } # no change in position
    # else
      # make a move closer



    #end


    # update the grid with "X" for all tail positions


  end

  # defp make_incremental_move()

  defp count_visited_pos(grid) do
    IO.puts "hey dont forget this"
  end

  defp build_grid(moves, grid_dimensions \\ {200, 200}, current_pos \\ {0,0}, starting_pos \\ {0, 0})

  defp build_grid([], {grid_width, grid_height}, final_pos, starting_pos) do
    IO.puts "final position: #{inspect final_pos}"
    IO.puts "width - height: " <> Integer.to_string(grid_width) <> " - " <> Integer.to_string(grid_height)
    %{
      starting_pos: starting_pos,
      grid: Enum.into(0..grid_height, [], fn (_) -> Enum.reduce(0..grid_width, [], fn _, rr -> rr ++ [0] end) end)
    }
  end

  # also want to know where the original starting point was....

  defp build_grid(moves, grid_dimensions, current_pos, starting_pos) do
    # we only need to know the dimensions at this stage; we grow them based on whats needed for the moves
    # then in the terminating state, we produce the actual grid
    # we start in a 0,0

    [current_move | remaining_moves] = moves
    { grid_width, grid_height } = grid_dimensions
    { pos_x, pos_y } = current_pos
    { starting_x, starting_y } = starting_pos
    # IO.puts "grid dimension: #{inspect grid_dimensions} current pos: #{inspect current_pos}, starting_pos: #{inspect starting_pos}, move: #{inspect current_move}"

    case current_move do
      {:R, x_moves} ->
        new_pos_x = pos_x + x_moves
        new_grid_width = if new_pos_x > grid_width, do: new_pos_x, else: grid_width

        # the new X represents the far Right edge
        build_grid(remaining_moves, {new_grid_width, grid_height}, {new_pos_x, pos_y}, starting_pos)
      {:L, x_moves} ->
        new_pos_x = pos_x - x_moves
        new_grid_width = if new_pos_x < 0, do: grid_width - new_pos_x, else: grid_width
        new_starting_x = if new_pos_x < 0, do: starting_x + new_grid_width - grid_width, else: starting_x
        new_pos_x = if new_pos_x < 0, do: 0, else: new_pos_x


        # set the X to 0 now since it represents the far Left edge
        build_grid(remaining_moves, {new_grid_width, grid_height}, {new_pos_x, pos_y}, {new_starting_x, starting_y})
      {:U, y_moves} ->
        new_pos_y = pos_y + y_moves
        new_grid_height = if new_pos_y > grid_height, do: new_pos_y, else: grid_height

        # the new Y represents the far Upper edge
        build_grid(remaining_moves, {grid_width, new_grid_height}, {pos_x, new_pos_y}, starting_pos)
      {:D, y_moves} ->
        new_pos_y = pos_y - y_moves # - 7
        new_grid_height = if new_pos_y < 0, do: grid_height - new_pos_y, else: grid_height
        new_starting_y = if new_pos_y < 0, do: starting_y + new_grid_height - grid_height, else: starting_y
        new_pos_y = if new_pos_y < 0, do: 0, else: new_pos_y

        # the new Y represents the far Bottom edge
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
