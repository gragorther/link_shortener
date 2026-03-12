defmodule LinkShortener.Shortenings.Shortening do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shortenings" do
    field :slug, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} ->
          "missing a scheme (e.g. https)"

        %URI{host: nil} ->
          "missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{field, error}]
        _ -> []
      end
    end)
  end

  @doc false
  def changeset(shortening, attrs) do
    shortening
    |> cast(attrs, [:slug, :url])
    |> validate_required([:slug, :url])
    |> validate_url(:url)
    |> unique_constraint(:slug)
  end
end
