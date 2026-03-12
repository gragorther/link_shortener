defmodule LinkShortenerWeb.ShorteningLive.Form do
  use LinkShortenerWeb, :live_view

  alias LinkShortener.Shortenings
  alias LinkShortener.Shortenings.Shortening

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
      </.header>

      <.form for={@form} id="shortening-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input field={@form[:url]} type="text" label="Url" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Shortening</.button>
          <!-- -- <.button navigate={return_path(@return_to, @shortening)}>Cancel</.button> -->
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     # |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    shortening = Shortenings.get_shortening!(id)

    socket
    |> assign(:page_title, "Edit Shortening")
    |> assign(:shortening, shortening)
    |> assign(:form, to_form(Shortenings.change_shortening(shortening)))
  end

  defp apply_action(socket, :new, _params) do
    shortening = %Shortening{}

    socket
    |> assign(:page_title, "New Shortening")
    |> assign(:shortening, shortening)
    |> assign(:form, to_form(Shortenings.change_shortening(shortening)))
  end

  @impl true
  def handle_event("validate", %{"shortening" => shortening_params}, socket) do
    changeset = Shortenings.change_shortening(socket.assigns.shortening, shortening_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"shortening" => shortening_params}, socket) do
    save_shortening(socket, socket.assigns.live_action, shortening_params)
  end

  defp save_shortening(socket, :edit, shortening_params) do
    case Shortenings.update_shortening(socket.assigns.shortening, shortening_params) do
      {:ok, shortening} ->
        {:noreply,
         socket
         #  |> put_flash(:info, "Shortening updated successfully")
         |> push_navigate(to: return_path(shortening))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_shortening(socket, :new, shortening_params) do
    case Shortenings.create_shortening(shortening_params) do
      {:ok, shortening} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shortening created successfully")
         |> push_navigate(to: return_path(shortening))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(shortening), do: ~p"/shortenings/#{shortening.slug}"
end
