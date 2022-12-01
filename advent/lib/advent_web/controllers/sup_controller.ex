require IEx

defmodule AdventWeb.SupController do
  use AdventWeb, :controller

  def index(conn, _params) do
    # IEx.pry
    render(conn, "index.html")
  end
end
