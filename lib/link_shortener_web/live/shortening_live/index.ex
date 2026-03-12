defmodule LinkShortenerWeb.ShorteningLive.Index do
  use LinkShortenerWeb, :live_view

  alias LinkShortener.Shortenings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Shortenings
        <:actions>
          <.button variant="primary" navigate={~p"/shortenings/new"}>
            <.icon name="hero-plus" /> New Shortening
          </.button>
        </:actions>
      </.header>

      <.table
        id="shortenings"
        rows={@streams.shortenings}
        row_click={fn {_id, shortening} -> JS.navigate(~p"/shortenings/#{shortening}") end}
      >
        <:col :let={{_id, shortening}} label="Slug">{shortening.slug}</:col>
        <:col :let={{_id, shortening}} label="Url">{shortening.url}</:col>
        <:action :let={{_id, shortening}}>
          <div class="sr-only">
            <.link navigate={~p"/shortenings/#{shortening}"}>Show</.link>
          </div>
          <.link navigate={~p"/shortenings/#{shortening}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, shortening}}>
          <.link
            phx-click={JS.push("delete", value: %{id: shortening.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Shortenings")
     |> stream(:shortenings, list_shortenings())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shortening = Shortenings.get_shortening!(id)
    {:ok, _} = Shortenings.delete_shortening(shortening)

    {:noreply, stream_delete(socket, :shortenings, shortening)}
  end

  defp list_shortenings() do
    Shortenings.list_shortenings()
  end
end
