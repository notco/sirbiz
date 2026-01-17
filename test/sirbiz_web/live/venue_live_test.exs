defmodule SirbizWeb.VenueLiveTest do
  use SirbizWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sirbiz.CRMFixtures

  @create_attrs %{name: "some name", address: "some address", phone: "some phone", is_active: true}
  @update_attrs %{name: "some updated name", address: "some updated address", phone: "some updated phone", is_active: false}
  @invalid_attrs %{name: nil, address: nil, phone: nil, is_active: false}
  defp create_venue(_) do
    venue = venue_fixture()

    %{venue: venue}
  end

  describe "Index" do
    setup [:create_venue]

    test "lists all venues", %{conn: conn, venue: venue} do
      {:ok, _index_live, html} = live(conn, ~p"/venues")

      assert html =~ "Listing Venues"
      assert html =~ venue.name
    end

    test "saves new venue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/venues")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Venue")
               |> render_click()
               |> follow_redirect(conn, ~p"/venues/new")

      assert render(form_live) =~ "New Venue"

      assert form_live
             |> form("#venue-form", venue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#venue-form", venue: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/venues")

      html = render(index_live)
      assert html =~ "Venue created successfully"
      assert html =~ "some name"
    end

    test "updates venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = live(conn, ~p"/venues")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#venues-#{venue.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/venues/#{venue}/edit")

      assert render(form_live) =~ "Edit Venue"

      assert form_live
             |> form("#venue-form", venue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#venue-form", venue: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/venues")

      html = render(index_live)
      assert html =~ "Venue updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = live(conn, ~p"/venues")

      assert index_live |> element("#venues-#{venue.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#venues-#{venue.id}")
    end
  end

  describe "Show" do
    setup [:create_venue]

    test "displays venue", %{conn: conn, venue: venue} do
      {:ok, _show_live, html} = live(conn, ~p"/venues/#{venue}")

      assert html =~ "Show Venue"
      assert html =~ venue.name
    end

    test "updates venue and returns to show", %{conn: conn, venue: venue} do
      {:ok, show_live, _html} = live(conn, ~p"/venues/#{venue}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/venues/#{venue}/edit?return_to=show")

      assert render(form_live) =~ "Edit Venue"

      assert form_live
             |> form("#venue-form", venue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#venue-form", venue: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/venues/#{venue}")

      html = render(show_live)
      assert html =~ "Venue updated successfully"
      assert html =~ "some updated name"
    end
  end
end
