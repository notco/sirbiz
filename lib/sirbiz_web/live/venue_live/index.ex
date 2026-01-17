defmodule SirbizWeb.VenueLive.Index do
  use SirbizWeb, :live_view

  alias Sirbiz.CRM

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Venues
        <:actions>
          <.button variant="primary" navigate={~p"/venues/new"}>
            <.icon name="hero-plus" /> New Venue
          </.button>
        </:actions>
      </.header>

      <.table
        id="venues"
        rows={@streams.venues}
        row_click={fn {_id, venue} -> JS.navigate(~p"/venues/#{venue}") end}
      >
        <:col :let={{_id, venue}} label="Name">{venue.name}</:col>
        <:col :let={{_id, venue}} label="Address">{venue.address}</:col>
        <:col :let={{_id, venue}} label="Phone">{venue.phone}</:col>
        <:col :let={{_id, venue}} label="Is active">{venue.is_active}</:col>
        <:action :let={{_id, venue}}>
          <div class="sr-only">
            <.link navigate={~p"/venues/#{venue}"}>Show</.link>
          </div>
          <.link navigate={~p"/venues/#{venue}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, venue}}>
          <.link
            phx-click={JS.push("delete", value: %{id: venue.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Venues")
     |> stream(:venues, list_venues())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    venue = CRM.get_venue!(id)
    {:ok, _} = CRM.delete_venue(venue)

    {:noreply, stream_delete(socket, :venues, venue)}
  end

  defp list_venues() do
    CRM.list_venues()
  end
end
