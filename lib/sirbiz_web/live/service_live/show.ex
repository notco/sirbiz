defmodule SirbizWeb.ServiceLive.Show do
  use SirbizWeb, :live_view

  alias Sirbiz.Booking

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Service {@service.id}
        <:subtitle>This is a service record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/services"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/services/#{@service}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit service
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@service.name}</:item>
        <:item title="Description">{@service.description}</:item>
        <:item title="Duration minutes">{@service.duration_minutes}</:item>
        <:item title="Is active">{@service.is_active}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Booking.subscribe_services(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Service")
     |> assign(:service, Booking.get_service!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Sirbiz.Booking.Service{id: id} = service},
        %{assigns: %{service: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :service, service)}
  end

  def handle_info(
        {:deleted, %Sirbiz.Booking.Service{id: id}},
        %{assigns: %{service: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current service was deleted.")
     |> push_navigate(to: ~p"/services")}
  end

  def handle_info({type, %Sirbiz.Booking.Service{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
