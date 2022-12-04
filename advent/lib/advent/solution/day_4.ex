defmodule Advent.Solution.Day4 do

  def part_one do
    Enum.reduce(get_problem_input, 0, fn pair, overlapping ->
      [[start1, end1],[start2, end2]] = pair

      range1 = Enum.to_list(start1..end1)
      range2 = Enum.to_list(start2..end2)

      cond do
        Enum.empty?(range1 -- range2) ->
          overlapping = overlapping + 1
        Enum.empty?(range2 -- range1) ->
          overlapping = overlapping + 1
        true ->
          overlapping
      end
    end)
  end

  ###

  def part_two do
    Enum.reduce(get_problem_input, 0, fn pair, overlapping ->
      [[start1, end1], [start2, end2]] = pair

      range1 = Enum.to_list(start1..end1)
      range2 = Enum.to_list(start2..end2)

      cond do
        length(range1 -- range2) < length(range1) ->
          overlapping = overlapping + 1
        length(range2 -- range1) < length(range2) ->
          overlapping = overlapping + 1
        true ->
          overlapping
      end
    end)
  end

  ###

  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(fn pair -> String.split(pair, ",") end)
    |> Enum.map(fn pair ->
      Enum.map(pair, fn p ->
        String.split(p, "-") |> Enum.map(fn num -> String.to_integer(num) end)
      end)
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(4, &parse_response_body/1)
  end
end
