defmodule LinkShortener.ShorteningsTest do
  use LinkShortener.DataCase

  alias LinkShortener.Shortenings

  describe "shortenings" do
    alias LinkShortener.Shortenings.Shortening

    import LinkShortener.ShorteningsFixtures

    @invalid_attrs %{url: nil, slug: nil}

    test "list_shortenings/0 returns all shortenings" do
      shortening = shortening_fixture()
      assert Shortenings.list_shortenings() == [shortening]
    end

    test "get_shortening!/1 returns the shortening with given id" do
      shortening = shortening_fixture()
      assert Shortenings.get_shortening!(shortening.id) == shortening
    end

    test "create_shortening/1 with valid data creates a shortening" do
      valid_attrs = %{url: "some url", slug: "some slug"}

      assert {:ok, %Shortening{} = shortening} = Shortenings.create_shortening(valid_attrs)
      assert shortening.url == "some url"
      assert shortening.slug == "some slug"
    end

    test "create_shortening/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shortenings.create_shortening(@invalid_attrs)
    end

    test "update_shortening/2 with valid data updates the shortening" do
      shortening = shortening_fixture()
      update_attrs = %{url: "some updated url", slug: "some updated slug"}

      assert {:ok, %Shortening{} = shortening} = Shortenings.update_shortening(shortening, update_attrs)
      assert shortening.url == "some updated url"
      assert shortening.slug == "some updated slug"
    end

    test "update_shortening/2 with invalid data returns error changeset" do
      shortening = shortening_fixture()
      assert {:error, %Ecto.Changeset{}} = Shortenings.update_shortening(shortening, @invalid_attrs)
      assert shortening == Shortenings.get_shortening!(shortening.id)
    end

    test "delete_shortening/1 deletes the shortening" do
      shortening = shortening_fixture()
      assert {:ok, %Shortening{}} = Shortenings.delete_shortening(shortening)
      assert_raise Ecto.NoResultsError, fn -> Shortenings.get_shortening!(shortening.id) end
    end

    test "change_shortening/1 returns a shortening changeset" do
      shortening = shortening_fixture()
      assert %Ecto.Changeset{} = Shortenings.change_shortening(shortening)
    end
  end
end
