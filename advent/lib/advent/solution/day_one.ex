defmodule Advent.Solution.DayOne do
  def part_one(elf_backpacks) do
    Enum.reduce(elf_backpacks, 0, fn elf_backpack, last_highest ->
      Enum.reduce(elf_backpack, 0, fn item, calories -> item + calories end)
      |> highest_one(last_highest)
    end)
  end

  def part_two(elf_backpacks) do
    Enum.reduce(elf_backpacks, [], fn elf_backpack, top_three ->
      Enum.reduce(elf_backpack, 0, fn item, calories -> item + calories end)
      |> highest_three(top_three)
    end)
    |> Enum.reduce(fn elf, total -> elf + total end)
  end

  defp highest_one(first, second) do
    Enum.sort([first, second]) |> List.last
  end

  defp highest_three(contender, current_set \\ []) do
    case current_three do
      [a, b, c] -> [contender | current_set] |> Enum.sort |> Enum.slice(1, 3)
      _ -> [contender | current_set]
    end
  end
end
