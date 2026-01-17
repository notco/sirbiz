defmodule SirbizWeb.AvailabilityLive.Index do
  use SirbizWeb, :live_view

  alias Sirbiz.Booking

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Availabilities
        <:actions>
          <.button variant="primary" navigate={~p"/availabilities/new"}>
            <.icon name="hero-plus" /> New Availability
          </.button>
        </:actions>
      </.header>

      <.table
        id="availabilities"
        rows={@streams.availabilities}
        row_click={fn {_id, availability} -> JS.navigate(~p"/availabilities/#{availability}") end}
      >
        <:col :let={{_id, availability}} label="Provider">
          {availability.provider.first_name} {availability.provider.last_name}
        </:col>
        <:col :let={{_id, availability}} label="Venue">{availability.venue.name}</:col>
        <:col :let={{_id, availability}} label="Day of week">{availability.day_of_week}</:col>
        <:col :let={{_id, availability}} label="Start time">{availability.start_time}</:col>
        <:col :let={{_id, availability}} label="End time">{availability.end_time}</:col>
        <:col :let={{_id, availability}} label="Is recurring">{availability.is_recurring}</:col>
        <:col :let={{_id, availability}} label="Specific date">{availability.specific_date}</:col>
        <:action :let={{_id, availability}}>
          <div class="sr-only">
            <.link navigate={~p"/availabilities/#{availability}"}>Show</.link>
          </div>
          <.link navigate={~p"/availabilities/#{availability}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, availability}}>
          <.link
            phx-click={JS.push("delete", value: %{id: availability.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Availabilities")
     |> stream(:availabilities, list_availabilities())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    availability = Booking.get_availability!(id)
    {:ok, _} = Booking.delete_availability(availability)

    {:noreply, stream_delete(socket, :availabilities, availability)}
  end

  defp list_availabilities() do
    Booking.list_availabilities()
    |> Sirbiz.Repo.preload([:provider, :venue])
  end
end
