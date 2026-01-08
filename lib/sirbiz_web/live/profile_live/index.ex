defmodule SirbizWeb.ProfileLive.Index do
  use SirbizWeb, :live_view

  alias Sirbiz.CRM

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Profiles
        <:actions>
          <.button variant="primary" navigate={~p"/profiles/new"}>
            <.icon name="hero-plus" /> New Profile
          </.button>
        </:actions>
      </.header>

      <.table
        id="profiles"
        rows={@streams.profiles}
        row_click={fn {_id, profile} -> JS.navigate(~p"/profiles/#{profile}") end}
      >
        <:col :let={{_id, profile}} label="First name">{profile.first_name}</:col>
        <:col :let={{_id, profile}} label="Last name">{profile.last_name}</:col>
        <:col :let={{_id, profile}} label="Phone">{profile.phone}</:col>
        <:col :let={{_id, profile}} label="Birthdate">{profile.birthdate}</:col>
        <:action :let={{_id, profile}}>
          <div class="sr-only">
            <.link navigate={~p"/profiles/#{profile}"}>Show</.link>
          </div>
          <.link navigate={~p"/profiles/#{profile}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, profile}}>
          <.link
            phx-click={JS.push("delete", value: %{id: profile.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Profiles")
     |> stream(:profiles, list_profiles())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    profile = CRM.get_profile!(id)
    {:ok, _} = CRM.delete_profile(profile)

    {:noreply, stream_delete(socket, :profiles, profile)}
  end

  defp list_profiles() do
    CRM.list_profiles()
  end
end
