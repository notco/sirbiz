defmodule SirbizWeb.AvailabilityLiveTest do
  use SirbizWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sirbiz.BookingFixtures

  @create_attrs %{day_of_week: 42, start_time: "14:00", end_time: "14:00", is_recurring: true, specific_date: "2026-01-16", deleted_at: "2026-01-16T15:24:00Z", activated_at: "2026-01-16T15:24:00Z", deactivated_at: "2026-01-16T15:24:00Z"}
  @update_attrs %{day_of_week: 43, start_time: "15:01", end_time: "15:01", is_recurring: false, specific_date: "2026-01-17", deleted_at: "2026-01-17T15:24:00Z", activated_at: "2026-01-17T15:24:00Z", deactivated_at: "2026-01-17T15:24:00Z"}
  @invalid_attrs %{day_of_week: nil, start_time: nil, end_time: nil, is_recurring: false, specific_date: nil, deleted_at: nil, activated_at: nil, deactivated_at: nil}
  defp create_availability(_) do
    availability = availability_fixture()

    %{availability: availability}
  end

  describe "Index" do
    setup [:create_availability]

    test "lists all availabilities", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/availabilities")

      assert html =~ "Listing Availabilities"
    end

    test "saves new availability", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/availabilities")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Availability")
               |> render_click()
               |> follow_redirect(conn, ~p"/availabilities/new")

      assert render(form_live) =~ "New Availability"

      assert form_live
             |> form("#availability-form", availability: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#availability-form", availability: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/availabilities")

      html = render(index_live)
      assert html =~ "Availability created successfully"
    end

    test "updates availability in listing", %{conn: conn, availability: availability} do
      {:ok, index_live, _html} = live(conn, ~p"/availabilities")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#availabilities-#{availability.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/availabilities/#{availability}/edit")

      assert render(form_live) =~ "Edit Availability"

      assert form_live
             |> form("#availability-form", availability: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#availability-form", availability: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/availabilities")

      html = render(index_live)
      assert html =~ "Availability updated successfully"
    end

    test "deletes availability in listing", %{conn: conn, availability: availability} do
      {:ok, index_live, _html} = live(conn, ~p"/availabilities")

      assert index_live |> element("#availabilities-#{availability.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#availabilities-#{availability.id}")
    end
  end

  describe "Show" do
    setup [:create_availability]

    test "displays availability", %{conn: conn, availability: availability} do
      {:ok, _show_live, html} = live(conn, ~p"/availabilities/#{availability}")

      assert html =~ "Show Availability"
    end

    test "updates availability and returns to show", %{conn: conn, availability: availability} do
      {:ok, show_live, _html} = live(conn, ~p"/availabilities/#{availability}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/availabilities/#{availability}/edit?return_to=show")

      assert render(form_live) =~ "Edit Availability"

      assert form_live
             |> form("#availability-form", availability: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#availability-form", availability: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/availabilities/#{availability}")

      html = render(show_live)
      assert html =~ "Availability updated successfully"
    end
  end
end
