defmodule TenancyWeb.ReviewLive.Index do
  use TenancyWeb, :live_view

  alias Tenancy.Inventory
  alias Tenancy.Inventory.Review

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :reviews, list_reviews())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Review")
    |> assign(:review, Inventory.get_review!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Review")
    |> assign(:review, %Review{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reviews")
    |> assign(:review, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Inventory.get_review!(id)
    {:ok, _} = Inventory.delete_review(review)

    {:noreply, assign(socket, :reviews, list_reviews())}
  end

  defp list_reviews do
    Inventory.list_reviews()
  end
end
