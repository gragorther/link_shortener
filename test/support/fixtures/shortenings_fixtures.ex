defmodule LinkShortener.ShorteningsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinkShortener.Shortenings` context.
  """

  @doc """
  Generate a unique shortening slug.
  """
  def unique_shortening_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a shortening.
  """
  def shortening_fixture(attrs \\ %{}) do
    {:ok, shortening} =
      attrs
      |> Enum.into(%{
        slug: unique_shortening_slug(),
        url: "some url"
      })
      |> LinkShortener.Shortenings.create_shortening()

    shortening
  end
end
