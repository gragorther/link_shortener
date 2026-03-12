defmodule LinkShortenerWeb.ShorteningLive.Show do
  alias Phoenix.LiveView
  use LinkShortenerWeb, :live_view

  alias LinkShortener.Shortenings
  @impl true
  def handle_params(_, url, socket) do
    copy_url = %{Map.from_struct(url |> URI.parse()) | path: "/#{socket.assigns.slug}"}
    {:noreply, assign(socket, :copy_link, URI.to_string(copy_url))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Shortening
        <:actions>
          <.button navigate={~p"/"}>
            <.icon name="hero-arrow-left" />
          </.button>
        </:actions>
      </.header>
      <p>
        You can access this shortening <.link class="text-blue-300" navigate={@shortening_path}>here</.link>.
      </p>
      <.copy_to_clipboard value={@copy_link} />
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    shortening_url = Shortenings.get_shortening_url_by_slug(slug)
    shortening_path = ~p"/#{slug}"
    # set the path to nil so that this can be used to make a copyable link

    {:ok,
     socket
     |> assign(:page_title, "Show Shortening")
     |> assign(:slug, slug)
     |> assign(:shortening_path, shortening_path)
     |> assign(:shortening_url, shortening_url)}
  end
end
