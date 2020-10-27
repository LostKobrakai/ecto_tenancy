defmodule Tenancy.InventoryTest do
  use Tenancy.DataCase

  alias Tenancy.Inventory

  describe "products" do
    alias Tenancy.Inventory.Product

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inventory.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Inventory.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Inventory.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Inventory.create_product(@valid_attrs)
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Inventory.update_product(product, @update_attrs)
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_product(product, @invalid_attrs)
      assert product == Inventory.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Inventory.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Inventory.change_product(product)
    end
  end

  describe "reviews" do
    alias Tenancy.Inventory.Review

    @valid_attrs %{body: "some body", name: "some name"}
    @update_attrs %{body: "some updated body", name: "some updated name"}
    @invalid_attrs %{body: nil, name: nil}

    def review_fixture(attrs \\ %{}) do
      {:ok, review} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inventory.create_review()

      review
    end

    test "list_reviews/0 returns all reviews" do
      review = review_fixture()
      assert Inventory.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture()
      assert Inventory.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      assert {:ok, %Review{} = review} = Inventory.create_review(@valid_attrs)
      assert review.body == "some body"
      assert review.name == "some name"
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture()
      assert {:ok, %Review{} = review} = Inventory.update_review(review, @update_attrs)
      assert review.body == "some updated body"
      assert review.name == "some updated name"
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_review(review, @invalid_attrs)
      assert review == Inventory.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture()
      assert {:ok, %Review{}} = Inventory.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture()
      assert %Ecto.Changeset{} = Inventory.change_review(review)
    end
  end
end
