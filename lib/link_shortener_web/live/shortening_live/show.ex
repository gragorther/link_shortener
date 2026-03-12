defmodule LinkShortenerWeb.ShorteningLive.Show do
  use LinkShortenerWeb, :live_view

  alias LinkShortener.Shortenings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Shortening {@shortening.id}
        <:subtitle>This is a shortening record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/"}>
            <.icon name="hero-arrow-left" />
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Slug">{@shortening.slug}</:item>
        <:item title="Url">{@shortening.url}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Shortening")
     |> assign(:shortening, Shortenings.get_shortening!(id))}
  end
end
