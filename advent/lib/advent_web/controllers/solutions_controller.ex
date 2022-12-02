require IEx

defmodule AdventWeb.SolutionsController do
  use AdventWeb, :controller

  def day(conn, params) do
    day = params["day"]

    mod = String.to_existing_atom("Elixir.Advent.Solution.Day#{day}")

    # result = case params["part"] do
    #   "1" -> mod.part_one
    #  "2" -> mod.part_two
    #end

    part_one = mod.part_one
    part_two = mod.part_two

    conn
    |> Plug.Conn.assign(:day, params["day"])
    |> Plug.Conn.assign(:part_one, part_one)
    |> Plug.Conn.assign(:part_two, part_two)
    |> render("index.html")
  end


end
