defmodule LinkShortenerWeb.PageController do
  use LinkShortenerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
