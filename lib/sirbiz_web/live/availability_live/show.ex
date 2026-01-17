defmodule SirbizWeb.AvailabilityLive.Show do
  use SirbizWeb, :live_view

  alias Sirbiz.Booking

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Availability {@availability.id}
        <:subtitle>This is a availability record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/availabilities"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/availabilities/#{@availability}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit availability
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Day of week">{@availability.day_of_week}</:item>
        <:item title="Start time">{@availability.start_time}</:item>
        <:item title="End time">{@availability.end_time}</:item>
        <:item title="Is recurring">{@availability.is_recurring}</:item>
        <:item title="Specific date">{@availability.specific_date}</:item>
        <:item title="Deleted at">{@availability.deleted_at}</:item>
        <:item title="Activated at">{@availability.activated_at}</:item>
        <:item title="Deactivated at">{@availability.deactivated_at}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Availability")
     |> assign(:availability, Booking.get_availability!(id))}
  end
end
