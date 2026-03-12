defmodule LinkShortenerWeb.ShorteningLiveTest do
  use LinkShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import LinkShortener.ShorteningsFixtures

  @create_attrs %{url: "some url", slug: "some slug"}
  @update_attrs %{url: "some updated url", slug: "some updated slug"}
  @invalid_attrs %{url: nil, slug: nil}
  defp create_shortening(_) do
    shortening = shortening_fixture()

    %{shortening: shortening}
  end

  describe "Index" do
    setup [:create_shortening]

    test "lists all shortenings", %{conn: conn, shortening: shortening} do
      {:ok, _index_live, html} = live(conn, ~p"/shortenings")

      assert html =~ "Listing Shortenings"
      assert html =~ shortening.slug
    end

    test "saves new shortening", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/shortenings")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Shortening")
               |> render_click()
               |> follow_redirect(conn, ~p"/shortenings/new")

      assert render(form_live) =~ "New Shortening"

      assert form_live
             |> form("#shortening-form", shortening: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#shortening-form", shortening: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/shortenings")

      html = render(index_live)
      assert html =~ "Shortening created successfully"
      assert html =~ "some slug"
    end

    test "updates shortening in listing", %{conn: conn, shortening: shortening} do
      {:ok, index_live, _html} = live(conn, ~p"/shortenings")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#shortenings-#{shortening.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/shortenings/#{shortening}/edit")

      assert render(form_live) =~ "Edit Shortening"

      assert form_live
             |> form("#shortening-form", shortening: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#shortening-form", shortening: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/shortenings")

      html = render(index_live)
      assert html =~ "Shortening updated successfully"
      assert html =~ "some updated slug"
    end

    test "deletes shortening in listing", %{conn: conn, shortening: shortening} do
      {:ok, index_live, _html} = live(conn, ~p"/shortenings")

      assert index_live |> element("#shortenings-#{shortening.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shortenings-#{shortening.id}")
    end
  end

  describe "Show" do
    setup [:create_shortening]

    test "displays shortening", %{conn: conn, shortening: shortening} do
      {:ok, _show_live, html} = live(conn, ~p"/shortenings/#{shortening}")

      assert html =~ "Show Shortening"
      assert html =~ shortening.slug
    end

    test "updates shortening and returns to show", %{conn: conn, shortening: shortening} do
      {:ok, show_live, _html} = live(conn, ~p"/shortenings/#{shortening}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/shortenings/#{shortening}/edit?return_to=show")

      assert render(form_live) =~ "Edit Shortening"

      assert form_live
             |> form("#shortening-form", shortening: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#shortening-form", shortening: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/shortenings/#{shortening}")

      html = render(show_live)
      assert html =~ "Shortening updated successfully"
      assert html =~ "some updated slug"
    end
  end
end
