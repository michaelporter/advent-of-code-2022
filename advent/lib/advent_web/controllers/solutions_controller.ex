require IEx

defmodule AdventWeb.SolutionsController do
  use AdventWeb, :controller

  def day(conn, params) do
    day_num = params["day"]

    { grid, count } = current_day(day_num).part_one

    conn
    |> Plug.Conn.assign(:day, day_num)
    |> Plug.Conn.assign(:grid, grid)
    |> Plug.Conn.assign(:count, count)
    |> Plug.Conn.assign(:part_two, current_day(day_num).part_two)
    |> render("index.html")
  end

  defp current_day(day_num) do
    String.to_existing_atom("Elixir.Advent.Solution.Day#{day_num}")
  end

end
