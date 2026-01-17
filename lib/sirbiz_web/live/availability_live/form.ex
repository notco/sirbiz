defmodule SirbizWeb.AvailabilityLive.Form do
  use SirbizWeb, :live_view

  alias Sirbiz.Booking
  alias Sirbiz.Booking.Availability
  alias Sirbiz.CRM

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage availability records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="availability-form" phx-change="validate" phx-submit="save">
        <!-- Provider Search -->
        <div>
          <%= if @selected_provider do %>
            <div class="mt-2 flex items-center gap-2">
              <.input
                type="text"
                name="provider_search"
                label="Provider"
                value={@selected_provider.first_name <> " " <> @selected_provider.last_name}
                placeholder="Search provider by name..."
                phx-keyup="search_provider"
                phx-debounce="300"
                disabled={true}
              />
              <button
                type="button"
                phx-click="clear_provider"
                class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
              >
                Clear
              </button>
            </div>
            <input type="hidden" name="availability[provider_id]" value={@selected_provider_id} />
          <% else %>
            <.input
              type="text"
              name="provider_search"
              label="Provider"
              value={@provider_search}
              placeholder="Search provider by name..."
              phx-keyup="search_provider"
              phx-debounce="300"
            />

            <%= if @provider_results != [] do %>
              <ul class="mt-2 border border-zinc-300 rounded-lg max-h-48 overflow-y-auto shadow-sm">
                <%= for provider <- @provider_results do %>
                  <li
                    phx-click="select_provider"
                    phx-value-id={provider.id}
                    class="px-3 py-2 hover:opacity-70 cursor-pointer border-b border-zinc-100 last:border-b-0"
                  >
                    <span class="text-sm"><%= provider.first_name %> <%= provider.last_name %></span>
                  </li>
                <% end %>
              </ul>
            <% end %>
          <% end %>
        </div>

        <!-- Venue Search -->
        <div>
          <%= if @selected_venue do %>
            <div class="mt-2 flex items-center gap-2">
              <.input
                type="text"
                name="venue_search"
                label="Venue"
                value={@selected_venue.name}
                placeholder="Search venue by name..."
                phx-keyup="search_venue"
                phx-debounce="300"
                disabled={true}
              />
              <button
                type="button"
                phx-click="clear_venue"
                class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
              >
                Clear
              </button>
            </div>
            <input type="hidden" name="availability[venue_id]" value={@selected_venue_id} />
          <% else %>
            <.input
              type="text"
              name="venue_search"
              label="Venue"
              value={@venue_search}
              placeholder="Search venue by name..."
              phx-keyup="search_venue"
              phx-debounce="300"
            />

            <%= if @venue_results != [] do %>
              <ul class="mt-2 border border-zinc-300 rounded-lg max-h-48 overflow-y-auto shadow-sm">
                <%= for venue <- @venue_results do %>
                  <li
                    phx-click="select_venue"
                    phx-value-id={venue.id}
                    class="px-3 py-2 hover:opacity-70 cursor-pointer border-b border-zinc-100 last:border-b-0"
                  >
                    <span class="text-sm"><%= venue.name %></span>
                  </li>
                <% end %>
              </ul>
            <% end %>
          <% end %>
        </div>

        <.input field={@form[:day_of_week]} type="number" label="Day of week (0=Sunday, 6=Saturday)" />
        <.input field={@form[:start_time]} type="time" label="Start time" />
        <.input field={@form[:end_time]} type="time" label="End time" />
        <.input field={@form[:is_recurring]} type="checkbox" label="Is recurring" />
        <.input field={@form[:specific_date]} type="date" label="Specific date (required for one-time)" />

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Availability</.button>
          <.button navigate={return_path(@return_to, @availability)}>Cancel</.button>
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
     |> assign(:provider_search, "")
     |> assign(:venue_search, "")
     |> assign(:provider_results, [])
     |> assign(:venue_results, [])
     |> assign(:selected_provider, nil)
     |> assign(:selected_venue, nil)
     |> assign(:selected_provider_id, nil)
     |> assign(:selected_venue_id, nil)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    availability = Booking.get_availability!(id) |> Sirbiz.Repo.preload([:provider, :venue])

    socket
    |> assign(:page_title, "Edit Availability")
    |> assign(:availability, availability)
    |> assign(:selected_provider, availability.provider)
    |> assign(:selected_venue, availability.venue)
    |> assign(:selected_provider_id, availability.provider_id)
    |> assign(:selected_venue_id, availability.venue_id)
    |> assign(:form, to_form(Booking.change_availability(availability)))
  end

  defp apply_action(socket, :new, _params) do
    availability = %Availability{}

    socket
    |> assign(:page_title, "New Availability")
    |> assign(:availability, availability)
    |> assign(:form, to_form(Booking.change_availability(availability)))
  end

  @impl true
  def handle_event("search_provider", %{"value" => query}, socket) do
    results = search_providers(query)

    {:noreply,
     socket
     |> assign(:provider_search, query)
     |> assign(:provider_results, results)}
  end

  def handle_event("select_provider", %{"id" => id}, socket) do
    provider = CRM.get_profile!(id)

    {:noreply,
     socket
     |> assign(:selected_provider, provider)
     |> assign(:selected_provider_id, id)
     |> assign(:provider_results, [])
     |> assign(:provider_search, "")}
  end

  def handle_event("clear_provider", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_provider, nil)
     |> assign(:selected_provider_id, nil)
     |> assign(:provider_search, "")}
  end

  def handle_event("search_venue", %{"value" => query}, socket) do
    results = search_venues(query)

    {:noreply,
     socket
     |> assign(:venue_search, query)
     |> assign(:venue_results, results)}
  end

  def handle_event("select_venue", %{"id" => id}, socket) do
    venue = CRM.get_venue!(id)

    {:noreply,
     socket
     |> assign(:selected_venue, venue)
     |> assign(:selected_venue_id, id)
     |> assign(:venue_results, [])
     |> assign(:venue_search, "")}
  end

  def handle_event("clear_venue", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_venue, nil)
     |> assign(:selected_venue_id, nil)
     |> assign(:venue_search, "")}
  end

  def handle_event("validate", %{"availability" => availability_params}, socket) do
    changeset = Booking.change_availability(socket.assigns.availability, availability_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"availability" => availability_params}, socket) do
    save_availability(socket, socket.assigns.live_action, availability_params)
  end

  defp save_availability(socket, :edit, availability_params) do
    case Booking.update_availability(socket.assigns.availability, availability_params) do
      {:ok, availability} ->
        {:noreply,
         socket
         |> put_flash(:info, "Availability updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, availability))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_availability(socket, :new, availability_params) do
    case Booking.create_availability(availability_params) do
      {:ok, availability} ->
        {:noreply,
         socket
         |> put_flash(:info, "Availability created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, availability))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _availability), do: ~p"/availabilities"
  defp return_path("show", availability), do: ~p"/availabilities/#{availability}"

  defp search_providers(query) when byte_size(query) < 2, do: []

  defp search_providers(query) do
    import Ecto.Query

    query = "%#{query}%"

    Sirbiz.Repo.all(
      from p in Sirbiz.CRM.Profile,
        where: ilike(p.first_name, ^query) or ilike(p.last_name, ^query),
        limit: 10
    )
  end

  defp search_venues(query) when byte_size(query) < 2, do: []

  defp search_venues(query) do
    import Ecto.Query

    query = "%#{query}%"

    Sirbiz.Repo.all(
      from v in Sirbiz.CRM.Venue,
        where: ilike(v.name, ^query),
        limit: 10
    )
  end
end
