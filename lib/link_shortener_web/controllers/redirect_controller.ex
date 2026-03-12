defmodule LinkShortenerWeb.RedirectController do
  use LinkShortenerWeb, :controller
  alias LinkShortener.Shortenings

  def redirect_request(conn, %{"slug" => slug}) do
    url = Shortenings.get_shortening_url_by_slug(slug)

    redirect(conn, external: url) |> Plug.Conn.put_status(301)
  end
end
