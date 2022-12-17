defmodule Advent.Solution.Day11 do

  def part_one do
    monkeys = parse_response_body

    monkey_count = 8

  end

  ###

  def part_two do
  end

  # I know there's an idiomatic way to get this but
  # I don't have internet
  defp divisible_by(int, by_int) do
    # fn int ->
    Float.to_string(int / by_int)
    |> String.split(".")
    |> Enum.at(1) == "0"
    # end
  end

  ###

  defp parse_response_body do

    [
      %{
        items: [98, 70, 75, 80, 84, 89, 55, 98],
        operation: &(&1 * 2),
        divisible_by: 11,
        true_destination: 1,
        false_destination: 2
      },
      %{
        items: [59],
        operation: &(&1 * &1),
        divisible_by: 19,
        true_destination: 7,
        false_destination: 3
      },
      %{
        items: [77, 95, 54, 65, 89],
        operation: &(&1 + 6),
        divisible_by: 7,
        true_destination: 0,
        false_destination: 5
      },
      %{
        items: [71, 64, 75],
        operation: &(&1 + 2),
        divisible_by: 17,
        true_destination: 6,
        false_destination: 2
      },
      %{
        items: [74, 55, 87, 98],
        operation: &(&1 * 11),
        divisible_by: 3,
        true_destination: 1,
        false_destination: 7
      },
      %{
        items: [90, 98, 85, 52, 91, 60],
        operation: &(&1 + 7),
        divisible_by: 5,
        true_destination: 0,
        false_destination: 4
      },
      %{
        items: [99, 51],
        operation: &(&1 + 1),
        divisible_by: 13,
        true_destination: 5,
        false_destination: 2
      },
      %{
        items: [98, 94, 59, 76, 51, 65, 75],
        operation: &(&1 + 5),
        divisible_by: 2,
        true_destination: 3,
        false_destination: 6
      }
    ]
  end


  defp get_problem_input do
    # Advent.InputFetcher.fetch_for_day(11, &parse_response_body/1)
    "Monkey 0:
    Starting items: 98, 70, 75, 80, 84, 89, 55, 98
    Operation: new = old * 2
    Test: divisible by 11
      If true: throw to monkey 1
      If false: throw to monkey 4

  Monkey 1:
    Starting items: 59
    Operation: new = old * old
    Test: divisible by 19
      If true: throw to monkey 7
      If false: throw to monkey 3

  Monkey 2:
    Starting items: 77, 95, 54, 65, 89
    Operation: new = old + 6
    Test: divisible by 7
      If true: throw to monkey 0
      If false: throw to monkey 5

  Monkey 3:
    Starting items: 71, 64, 75
    Operation: new = old + 2
    Test: divisible by 17
      If true: throw to monkey 6
      If false: throw to monkey 2

  Monkey 4:
    Starting items: 74, 55, 87, 98
    Operation: new = old * 11
    Test: divisible by 3
      If true: throw to monkey 1
      If false: throw to monkey 7

  Monkey 5:
    Starting items: 90, 98, 85, 52, 91, 60
    Operation: new = old + 7
    Test: divisible by 5
      If true: throw to monkey 0
      If false: throw to monkey 4

  Monkey 6:
    Starting items: 99, 51
    Operation: new = old + 1
    Test: divisible by 13
      If true: throw to monkey 5
      If false: throw to monkey 2

  Monkey 7:
    Starting items: 98, 94, 59, 76, 51, 65, 75
    Operation: new = old + 5
    Test: divisible by 2
      If true: throw to monkey 3
      If false: throw to monkey 6"
    # |> parse_response_body
  end
end
