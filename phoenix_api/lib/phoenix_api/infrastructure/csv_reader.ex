defmodule PhoenixApi.Infra.CSVReader do
  @moduledoc "Loeading CSV files fromz priv/data"

  @doc """
  Reads CSV, ignores header, and returns first `count` records.
  """
  def read(file_name, count \\ 100) do
    path = Path.join(:code.priv_dir(:phoenix_api), "data/#{file_name}")

    path
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&parse_line/1)
    |> Enum.take(count)
  end

  defp parse_line(line) do
    [name | _rest] = String.split(line, ",")
    String.trim(name)
  end
end
