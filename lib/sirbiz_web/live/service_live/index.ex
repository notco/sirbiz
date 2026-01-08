defmodule SirbizWeb.ServiceLive.Index do
  use SirbizWeb, :live_view

  alias Sirbiz.Booking

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Services
        <:actions>
          <.button variant="primary" navigate={~p"/services/new"}>
            <.icon name="hero-plus" /> New Service
          </.button>
        </:actions>
      </.header>

      <.table
        id="services"
        rows={@streams.services}
        row_click={fn {_id, service} -> JS.navigate(~p"/services/#{service}") end}
      >
        <:col :let={{_id, service}} label="Name">{service.name}</:col>
        <:col :let={{_id, service}} label="Description">{service.description}</:col>
        <:col :let={{_id, service}} label="Duration minutes">{service.duration_minutes}</:col>
        <:col :let={{_id, service}} label="Is active">{service.is_active}</:col>
        <:action :let={{_id, service}}>
          <div class="sr-only">
            <.link navigate={~p"/services/#{service}"}>Show</.link>
          </div>
          <.link navigate={~p"/services/#{service}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, service}}>
          <.link
            phx-click={JS.push("delete", value: %{id: service.id}) |> hide("##{id}")}
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
    if connected?(socket) do
      Booking.subscribe_services(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Services")
     |> stream(:services, list_services(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    service = Booking.get_service!(socket.assigns.current_scope, id)
    {:ok, _} = Booking.delete_service(socket.assigns.current_scope, service)

    {:noreply, stream_delete(socket, :services, service)}
  end

  @impl true
  def handle_info({type, %Sirbiz.Booking.Service{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :services, list_services(socket.assigns.current_scope), reset: true)}
  end

  defp list_services(current_scope) do
    Booking.list_services(current_scope)
  end
end
