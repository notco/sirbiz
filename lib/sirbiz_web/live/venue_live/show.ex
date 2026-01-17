defmodule SirbizWeb.VenueLive.Show do
  use SirbizWeb, :live_view

  alias Sirbiz.CRM

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Venue {@venue.id}
        <:subtitle>This is a venue record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/venues"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/venues/#{@venue}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit venue
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@venue.name}</:item>
        <:item title="Address">{@venue.address}</:item>
        <:item title="Phone">{@venue.phone}</:item>
        <:item title="Is active">{@venue.is_active}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Venue")
     |> assign(:venue, CRM.get_venue!(id))}
  end
end
