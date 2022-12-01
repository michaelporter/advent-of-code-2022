# require IEx

defmodule AdventWeb.SolutionsController do
  use AdventWeb, :controller

  def day_one_part_one(conn, params) do
    result = Advent.Solution.DayOne.part_one()

    conn
    |> Plug.Conn.assign(:day, params["day"])
    |> Plug.Conn.assign(:result, result)
    |> render("index.html")
  end
end
