defmodule Advent.Solution.Day7 do

  # we are trying to find file space to clean up
  #
  # first ask is to find all directories whose size adds up to <= 100,000
  #
  # then, we get the sum of the sizes of these directories.
  #
  # the instructions also say we are expected to count files more than once
  #

  def part_one do
    # my strategy, I think:
    # build the file tree as a data structure, then recursively iterate over it to get the counts
    get_problem_input
    |> build_file_system(["/"], %{"/" => %{}})

    "got it?"

  end

  defp build_file_system([], _current_path, tree) do
    IO.puts "in final one"
    tree
  end

  defp build_file_system(cmds, current_path, tree) do
    [cmd | rest] = cmds

    # currently:
    # I think I have all the "$ cd" lines figured
    # next would be the "$ ls", which should populate child keys with
    # both files and directories
    # then comes the summing of file sizes and associating that with directories

    cond do
      Regex.match?(~r/^\$ cd \.\./, cmd) ->
        IO.puts "in CD .."
        # [_, c, dest_dir] = String.split(cmd, " ")

        # current_dir = get_in(tree, current_path)
        {new_path, _} = Enum.split(current_path, length(current_path) - 1)
        build_file_system(rest, new_path, tree)

      Regex.match?(~r/^\$ cd \//, cmd) ->
        IO.puts "in the root one"
        if !Map.has_key?(tree, "/") do
          Map.put tree, "/", %{}
        end

        build_file_system(rest, ["/"], tree)

      Regex.match?(~r/^\$ cd/, cmd) ->
        [_, _c, dest_dir] = String.split(cmd, " ", trim: true)

        current_dir = get_in(tree, current_path)

        if Map.has_key?(current_dir, dest_dir) do
          build_file_system(rest, current_path ++ [dest_dir], tree)
        else
          {_, updated_tree} = get_and_update_in(tree, current_path, fn val -> {
            val,
            Map.put(val, dest_dir, %{})
          } end)

          build_file_system(rest, current_path ++ [dest_dir], updated_tree)
        end

      true -> IO.puts "oops"
    end
  end



  ###

  def part_two do
    get_problem_input
  end

  ###


  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    |> Enum.filter(fn row -> Regex.match?(~r/^\$ cd/, row) end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(7, &parse_response_body/1)
  end
end
