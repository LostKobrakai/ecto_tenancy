defmodule TenancyWeb.ReviewLiveTest do
  use TenancyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Tenancy.Inventory

  @create_attrs %{body: "some body", name: "some name"}
  @update_attrs %{body: "some updated body", name: "some updated name"}
  @invalid_attrs %{body: nil, name: nil}

  defp fixture(:review) do
    {:ok, review} = Inventory.create_review(@create_attrs)
    review
  end

  defp create_review(_) do
    review = fixture(:review)
    %{review: review}
  end

  describe "Index" do
    setup [:create_review]

    test "lists all reviews", %{conn: conn, review: review} do
      {:ok, _index_live, html} = live(conn, Routes.review_index_path(conn, :index))

      assert html =~ "Listing Reviews"
      assert html =~ review.body
    end

    test "saves new review", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.review_index_path(conn, :index))

      assert index_live |> element("a", "New Review") |> render_click() =~
               "New Review"

      assert_patch(index_live, Routes.review_index_path(conn, :new))

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#review-form", review: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.review_index_path(conn, :index))

      assert html =~ "Review created successfully"
      assert html =~ "some body"
    end

    test "updates review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, Routes.review_index_path(conn, :index))

      assert index_live |> element("#review-#{review.id} a", "Edit") |> render_click() =~
               "Edit Review"

      assert_patch(index_live, Routes.review_index_path(conn, :edit, review))

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#review-form", review: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.review_index_path(conn, :index))

      assert html =~ "Review updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, Routes.review_index_path(conn, :index))

      assert index_live |> element("#review-#{review.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#review-#{review.id}")
    end
  end

  describe "Show" do
    setup [:create_review]

    test "displays review", %{conn: conn, review: review} do
      {:ok, _show_live, html} = live(conn, Routes.review_show_path(conn, :show, review))

      assert html =~ "Show Review"
      assert html =~ review.body
    end

    test "updates review within modal", %{conn: conn, review: review} do
      {:ok, show_live, _html} = live(conn, Routes.review_show_path(conn, :show, review))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Review"

      assert_patch(show_live, Routes.review_show_path(conn, :edit, review))

      assert show_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#review-form", review: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.review_show_path(conn, :show, review))

      assert html =~ "Review updated successfully"
      assert html =~ "some updated body"
    end
  end
end
