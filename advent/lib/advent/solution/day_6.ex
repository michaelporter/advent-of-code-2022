defmodule Advent.Solution.Day6 do

  # lock on to an elf's signal
  # signal is a string of random chars received one at a time
  # must detect the start-of-packet marker from the stream

  # the start of a packet is indicated by
  # a sequence of 4 chars that are all different

  # puzzle input is a datastream buffer
  # solution must ID the first position where the 4 most recently
  # received chars are different
  # => report the number of chars from the start of the buff
  # to the end of the first 4-char marker
  # so its 4 + n

  def part_one do
    get_problem_input
    |> find_uniq_chunk(0)
  end

  defp find_uniq_chunk(data, count_from_start) do
    chunk = Enum.take(data, 4)

    if length(Enum.uniq(chunk)) == 4 do
      count_from_start + 4
    else
      {_, chopped} = Enum.split(data, 1)
      find_uniq_chunk(chopped, count_from_start + 1)
    end
  end

  ###

  def part_two do
  end

  ###


  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("", trim: true)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(6, &parse_response_body/1)
  end
end
