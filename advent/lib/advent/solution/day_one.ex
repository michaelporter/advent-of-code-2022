defmodule Advent.Solution.DayOne do
  def part_one(elf_backpacks) do
    Enum.reduce(elf_backpacks, 0, fn elf_backpack, last_highest ->
      Enum.reduce(elf_backpack, 0, fn item, calories ->
        String.to_integer(item) + calories
      end)
      |> highest_one(last_highest)
    end)
  end

  def part_two(elf_backpacks) do
    Enum.reduce(elf_backpacks, [], fn elf_backpack, top_three ->
      Enum.reduce(elf_backpack, 0, fn item, calories ->
        String.to_integer(item) + calories
      end)
      |> highest_three(top_three)
    end)
    |> Enum.reduce(fn (elf, total) -> elf + total end)
  end

  defp highest_one(first, second) do # this feels bad
    cond do
      first < second -> second
      true -> first
    end
  end

  defp highest_three(contender, []) do
    [contender]
  end

  defp highest_three(contender, [a]) do
    [contender, a]
  end

  defp highest_three(contender, [a, b]) do
    [contender, a, b]
  end

  defp highest_three(contender, current_three) do
    [contender | current_three] |> Enum.sort |> Enum.slice(1, 3)
  end
end
