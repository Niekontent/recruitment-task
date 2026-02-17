defmodule PhoenixApi.Domain.Users.UserQueries do
  @moduledoc """
  Provides filtering and sorting utilities for User queries.

  Designed to operate on `Ecto.Query` structs and accept
  raw params (e.g. from controller `conn.params`).
  """

  import Ecto.Query

  @doc """
  Applies dynamic filters to the given query.

  Supported params:

    * "first_name" - exact match
    * "last_name"  - exact match
    * "gender"     - exact match
    * "birthdate_from" - lower bound (>=)
    * "birthdate_to"   - upper bound (<=)

  Returns updated `Ecto.Query`.
  """
  @spec filter(Ecto.Query.t(), map()) :: Ecto.Query.t()
  def filter(query, params) do
    query
    |> maybe_filter(:first_name, Map.get(params, "first_name"))
    |> maybe_filter(:last_name, Map.get(params, "last_name"))
    |> maybe_filter(:gender, Map.get(params, "gender"))
    |> maybe_filter_date(:birthdate, Map.get(params, "birthdate_from"), :>=)
    |> maybe_filter_date(:birthdate, Map.get(params, "birthdate_to"), :<=)
  end

  @doc """
  Applies dynamic sorting to the given query.

  Supported params:

    * "sort_by" - one of: id, first_name, last_name, gender, birthdate
    * "sort_order" - "asc" or "desc"

  Defaults:
    * sort_by: "id"
    * sort_order: "asc"

  Invalid values fallback to defaults.
  """
  @spec sort(Ecto.Query.t(), map()) :: Ecto.Query.t()
  def sort(query, params) do
    sort_by = Map.get(params, "sort_by", "id")
    sort_order = Map.get(params, "sort_order", "asc")

    field_atom =
      case sort_by do
        "id" -> :id
        "first_name" -> :first_name
        "last_name" -> :last_name
        "gender" -> :gender
        "birthdate" -> :birthdate
        _ -> :id
      end

    order_atom =
      case sort_order do
        "asc" -> :asc
        "desc" -> :desc
        _ -> :asc
      end

    order_by(query, [u], [{^order_atom, field(u, ^field_atom)}])
  end

  defp maybe_filter(query, _field, nil), do: query

  defp maybe_filter(query, _field, ""), do: query

  defp maybe_filter(query, field, value) do
    where(query, [u], ilike(field(u, ^field), ^"#{value}"))
  end

  defp maybe_filter_date(query, _field, nil, _op), do: query

  defp maybe_filter_date(query, _field, "", _op), do: query

  defp maybe_filter_date(query, field, value, :>=) do
    where(query, [u], field(u, ^field) >= ^value)
  end

  defp maybe_filter_date(query, field, value, :<=) do
    where(query, [u], field(u, ^field) <= ^value)
  end
end
