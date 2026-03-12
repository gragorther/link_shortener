defmodule LinkShortener.Shortenings do
  @moduledoc """
  The Shortenings context.
  """

  import Ecto.Query, warn: false
  alias LinkShortener.Repo

  alias LinkShortener.Shortenings.Shortening

  @doc """
  Returns the list of shortenings.

  ## Examples

      iex> list_shortenings()
      [%Shortening{}, ...]

  """
  def list_shortenings do
    Repo.all(Shortening)
  end

  @doc """
  Gets a single shortening.

  Raises `Ecto.NoResultsError` if the Shortening does not exist.

  ## Examples

      iex> get_shortening!(123)
      %Shortening{}

      iex> get_shortening!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shortening!(id) do
    Repo.get!(Shortening, id)
  end

  def get_shortening_url_by_slug(slug) do
    Repo.one(from s in Shortening, where: s.slug == ^slug, select: s.url)
  end

  @doc """
  Creates a shortening.

  ## Examples

      iex> create_shortening(%{field: value})
      {:ok, %Shortening{}}

      iex> create_shortening(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shortening(attrs) do
    %Shortening{}
    |> Shortening.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shortening.

  ## Examples

      iex> update_shortening(shortening, %{field: new_value})
      {:ok, %Shortening{}}

      iex> update_shortening(shortening, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shortening(%Shortening{} = shortening, attrs) do
    shortening
    |> Shortening.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shortening.

  ## Examples

      iex> delete_shortening(shortening)
      {:ok, %Shortening{}}

      iex> delete_shortening(shortening)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shortening(%Shortening{} = shortening) do
    Repo.delete(shortening)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shortening changes.

  ## Examples

      iex> change_shortening(shortening)
      %Ecto.Changeset{data: %Shortening{}}

  """
  def change_shortening(%Shortening{} = shortening, attrs \\ %{}) do
    Shortening.changeset(shortening, attrs)
  end
end
