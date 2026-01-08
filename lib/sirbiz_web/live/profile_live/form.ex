defmodule SirbizWeb.ProfileLive.Form do
  use SirbizWeb, :live_view

  alias Sirbiz.CRM
  alias Sirbiz.CRM.Profile

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage profile records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="profile-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <.input field={@form[:birthdate]} type="date" label="Birthdate" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Profile</.button>
          <.button navigate={return_path(@return_to, @profile)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    profile = CRM.get_profile!(id)

    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:profile, profile)
    |> assign(:form, to_form(CRM.change_profile(profile)))
  end

  defp apply_action(socket, :new, _params) do
    profile = %Profile{}

    socket
    |> assign(:page_title, "New Profile")
    |> assign(:profile, profile)
    |> assign(:form, to_form(CRM.change_profile(profile)))
  end

  @impl true
  def handle_event("validate", %{"profile" => profile_params}, socket) do
    changeset = CRM.change_profile(socket.assigns.profile, profile_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"profile" => profile_params}, socket) do
    save_profile(socket, socket.assigns.live_action, profile_params)
  end

  defp save_profile(socket, :edit, profile_params) do
    case CRM.update_profile(socket.assigns.profile, profile_params) do
      {:ok, profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, profile))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_profile(socket, :new, profile_params) do
    case CRM.create_profile(profile_params) do
      {:ok, profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, profile))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _profile), do: ~p"/profiles"
  defp return_path("show", profile), do: ~p"/profiles/#{profile}"
end
