defmodule Advent.Solution.Day11 do

  def part_one do
    monkeys = get_problem_input

    iterations = Enum.to_list (0..19)

    Enum.reduce(iterations, monkeys, fn (iteration, monkey_state) ->
      monkeys
      |> Enum.with_index
      |> Enum.reduce(monkey_state, fn ({_, current_index}, monkey_state) ->
        current_monkey = Enum.at(monkey_state, current_index)

        %{
          items: items,
          operation: operation,
          test: test,
          true_destination: true_destination,
          false_destination: false_destination,
          inspections: inspections
        } = current_monkey

        monkey_moves = Enum.into(monkeys, [], fn _ -> [] end)

        monkey_moves = Enum.reduce(items, monkey_moves, fn(item, monkey_moves) ->
          upon_inspection = operation.(item)
          unharmed_object = (upon_inspection / 3)
          |> Float.to_string
          |> String.split(".")
          |> List.first
          |> String.to_integer

          dest_monkey_index = if test.(unharmed_object), do: true_destination, else: false_destination

          List.update_at(monkey_moves, dest_monkey_index, fn monk -> monk ++ [unharmed_object] end)
        end)

        monkey_state = List.update_at(monkey_state, current_index, fn monk ->
          Map.replace(monk, :inspections, monk[:inspections] + length(items))
        end)

        monkey_state = List.update_at(monkey_state, current_index, fn monk ->
          Map.replace(monk, :items, [])
        end)

        monkey_moves
        |> Enum.with_index
        |> Enum.reduce(monkey_state, fn({monkey_move, monkey_index}, state) ->

          List.update_at(state, monkey_index, fn monk ->
            current_items = monk[:items]
            Map.replace(monk, :items, current_items ++ monkey_move)
          end)
        end)
      end)
    end)
    |> Enum.map(fn r -> r[:inspections] end)
    |> Enum.sort
    |> Enum.take(-2)
    |> Enum.reduce(1, fn(monk, prod) -> monk * prod end)
  end

  ###

  def part_two do
  end

  ###

  defp parse_response_body do
    [
      %{
        items: [98, 70, 75, 80, 84, 89, 55, 98],
        operation: &(&1 * 2),
        test: &(rem(&1, 11) == 0),
        true_destination: 1,
        false_destination: 4,
        inspections: 0
      },
      %{
        items: [59],
        operation: &(&1 * &1),
        test: &(rem(&1, 19) == 0),
        true_destination: 7,
        false_destination: 3,
        inspections: 0
      },
      %{
        items: [77, 95, 54, 65, 89],
        operation: &(&1 + 6),
        test: &(rem(&1, 7) == 0),
        true_destination: 0,
        false_destination: 5,
        inspections: 0
      },
      %{
        items: [71, 64, 75],
        operation: &(&1 + 2),
        test: &(rem(&1, 17) == 0),
        true_destination: 6,
        false_destination: 2,
        inspections: 0
      },
      %{
        items: [74, 55, 87, 98],
        operation: &(&1 * 11),
        test: &(rem(&1, 3) == 0),
        true_destination: 1,
        false_destination: 7,
        inspections: 0
      },
      %{
        items: [90, 98, 85, 52, 91, 60],
        operation: &(&1 + 7),
        test: &(rem(&1, 5) == 0),
        true_destination: 0,
        false_destination: 4,
        inspections: 0
      },
      %{
        items: [99, 51],
        operation: &(&1 + 1),
        test: &(rem(&1, 13) == 0),
        true_destination: 5,
        false_destination: 2,
        inspections: 0
      },
      %{
        items: [98, 94, 59, 76, 51, 65, 75],
        operation: &(&1 + 5),
        test: &(rem(&1, 2) == 0),
        true_destination: 3,
        false_destination: 6,
        inspections: 0
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


    parse_response_body
  end
end
