require IEx

defmodule AdventWeb.SolutionsController do
  use AdventWeb, :controller

  def day_one_part_one(conn, params) do
    input_data = fetch_input_data(1)
    result = Advent.Solution.DayOne.part_one(input_data)

    conn
    |> Plug.Conn.assign(:day, params["day"])
    |> Plug.Conn.assign(:result, result)
    |> render("index.html")
  end

  def day_one_part_two(conn, params) do # obv repetitive and the route is hardcoded
    input_data = fetch_input_data(1)
    result = Advent.Solution.DayOne.part_two(input_data)

    conn
    |> Plug.Conn.assign(:day, params["day"])
    |> Plug.Conn.assign(:result, result)
    |> render("index.html")
  end

  def fetch_input_data(day_number) do
    session_id = System.get_env("ADVENT_SESSION_ID")
    uri = "https://adventofcode.com/2022/day/#{day_number}/input"
    headers = %{ 'Cookie' => "session=#{session_id}" }

    case HTTPoison.get(uri, headers) do
      {:ok, %{status_code: 200, body: body}} -> parse_response_body(body)
      # {:error, %{reason: reason}} -> reason
      # not dealing with error cases since these are all one-offs
    end
  end

  defp parse_response_body(body) do
    String.trim_trailing(body)
    |> String.split("\n\n")
    |> Enum.map(fn elf ->
      String.split(elf, "\n")
      |> Enum.map(fn item -> String.to_integer(item) end)
    end)
  end
end
