require IEx

defmodule AdventWeb.SolutionsController do
  use AdventWeb, :controller

  def day(conn, params) do
    day_num = params["day"]

    if day_num == "9" do

      { grid_part_one, count_part_one } = current_day(day_num).part_one
      { grid_part_two, count_part_two } = current_day(day_num).part_two

      conn
      |> Plug.Conn.assign(:day, day_num)
      |> Plug.Conn.assign(:grid_part_one, grid_part_one)
      |> Plug.Conn.assign(:count_part_one, count_part_one)
      |> Plug.Conn.assign(:grid_part_two, grid_part_two)
      |> Plug.Conn.assign(:count_part_two, count_part_two)
      |> Plug.Conn.assign(:part_two, "hey") #current_day(day_num).part_two)
      |> render("day_9.html")
    else
      conn
      |> Plug.Conn.assign(:day, day_num)
      |> Plug.Conn.assign(:part_one, current_day(day_num).part_one)
      |> Plug.Conn.assign(:part_two, current_day(day_num).part_two)
      |> render("index.html")
    end
  end

  defp current_day(day_num) do
    String.to_existing_atom("Elixir.Advent.Solution.Day#{day_num}")
  end

end
