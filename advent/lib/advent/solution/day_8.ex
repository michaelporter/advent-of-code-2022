defmodule Advent.Solution.Day8 do

  # find how many trees are visible from the edge
  # when looking in from a row or column end

  # trees are represented by a number that reflects its height
  # - 0 is shortest, 9 is tallest (10 sizes)

  # a tree is visible if the trees between it and the edge of
  # the viewer are shorter than it is

  # 0 1 2 == all three are visible
  # 1 0 3 == 1 and 3 are visible (so 2)

  # every tree along the edge is visible

  def part_one do
    { rows, cols } = get_problem_input

    Enum.reduce(Enum.with_index(rows), 0, fn {row, row_index}, all_visible_trees ->
      visible_trees_in_row = Enum.reduce(Enum.with_index(row), 0, fn {tree, tree_index}, visible_trees ->
        left = Enum.take(row, tree_index)
        right = Enum.take(row, tree_index + 1 - length(row))
        top = Enum.take(rows, row_index) |> Enum.map(fn row -> Enum.at(row, tree_index) end)
        bottom = Enum.take(rows, row_index + 1 - length(rows)) |> Enum.map(fn row -> Enum.at(row, tree_index) end)


        cond do
          row_index == 0 || tree_index == 0 || row_index == length(rows) - 1 || tree_index == length(row) - 1 ->
            visible_trees + 1
          true ->
            visible_paths = Enum.filter([left, right, top, bottom], fn dir ->
              shorter_trees = Enum.filter(dir, fn t -> t < tree end)
              # IO.puts "#{tree} > #{inspect(Enum.sort(shorter_trees))}"
              length(shorter_trees) == length(dir)
            end)

            if length(visible_paths) > 0 do
              visible_trees + 1
            else
              visible_trees
            end
        end
      end)

      all_visible_trees + visible_trees_in_row
    end)

    # return:
    # number_of_visible_trees
  end

  ###

  def part_two do


  end

  ###

  defp parse_response_body(body) do
    rows = body
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      String.split(s, "", trim: true)
      |> Enum.map(fn n -> # nested loop is not great but this is fast enough for part 1
        String.to_integer(n)
      end)
    end)

    cols = rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)


    {rows, cols}
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(8, &parse_response_body/1)
  end
end
