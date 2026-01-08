defmodule SirbizWeb.ProfileLive.Show do
  use SirbizWeb, :live_view

  alias Sirbiz.CRM

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Profile {@profile.id}
        <:subtitle>This is a profile record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/profiles"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/profiles/#{@profile}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit profile
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="First name">{@profile.first_name}</:item>
        <:item title="Last name">{@profile.last_name}</:item>
        <:item title="Phone">{@profile.phone}</:item>
        <:item title="Birthdate">{@profile.birthdate}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Profile")
     |> assign(:profile, CRM.get_profile!(id))}
  end
end
