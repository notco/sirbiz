defmodule SirbizWeb.ProfileLiveTest do
  use SirbizWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sirbiz.CRMFixtures

  @create_attrs %{first_name: "some first_name", last_name: "some last_name", phone: "some phone", birthdate: "2026-01-05"}
  @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", phone: "some updated phone", birthdate: "2026-01-06"}
  @invalid_attrs %{first_name: nil, last_name: nil, phone: nil, birthdate: nil}
  defp create_profile(_) do
    profile = profile_fixture()

    %{profile: profile}
  end

  describe "Index" do
    setup [:create_profile]

    test "lists all profiles", %{conn: conn, profile: profile} do
      {:ok, _index_live, html} = live(conn, ~p"/profiles")

      assert html =~ "Listing Profiles"
      assert html =~ profile.first_name
    end

    test "saves new profile", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/profiles")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Profile")
               |> render_click()
               |> follow_redirect(conn, ~p"/profiles/new")

      assert render(form_live) =~ "New Profile"

      assert form_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#profile-form", profile: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/profiles")

      html = render(index_live)
      assert html =~ "Profile created successfully"
      assert html =~ "some first_name"
    end

    test "updates profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, ~p"/profiles")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#profiles-#{profile.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/profiles/#{profile}/edit")

      assert render(form_live) =~ "Edit Profile"

      assert form_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#profile-form", profile: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/profiles")

      html = render(index_live)
      assert html =~ "Profile updated successfully"
      assert html =~ "some updated first_name"
    end

    test "deletes profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, ~p"/profiles")

      assert index_live |> element("#profiles-#{profile.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#profiles-#{profile.id}")
    end
  end

  describe "Show" do
    setup [:create_profile]

    test "displays profile", %{conn: conn, profile: profile} do
      {:ok, _show_live, html} = live(conn, ~p"/profiles/#{profile}")

      assert html =~ "Show Profile"
      assert html =~ profile.first_name
    end

    test "updates profile and returns to show", %{conn: conn, profile: profile} do
      {:ok, show_live, _html} = live(conn, ~p"/profiles/#{profile}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/profiles/#{profile}/edit?return_to=show")

      assert render(form_live) =~ "Edit Profile"

      assert form_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#profile-form", profile: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/profiles/#{profile}")

      html = render(show_live)
      assert html =~ "Profile updated successfully"
      assert html =~ "some updated first_name"
    end
  end
end
