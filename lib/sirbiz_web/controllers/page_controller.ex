defmodule SirbizWeb.PageController do
  use SirbizWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
