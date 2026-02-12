defmodule PhoenixApi.Domain.Users.Types.Gender do
  @behaviour Ecto.Type

  @values [:male, :female]

  def type, do: :string

  def load(value) when is_binary(value) do
    atom = String.to_existing_atom(value)
    if atom in @values, do: {:ok, atom}, else: :error
  end

  def dump(value) when value in @values do
    {:ok, Atom.to_string(value)}
  end

  def dump(_), do: :error

  def cast(value) when is_binary(value) do
    atom = String.to_existing_atom(value)
    if atom in @values, do: {:ok, atom}, else: :error
  end

  def cast(value) when value in @values, do: {:ok, value}
  def cast(_), do: :error

  def values, do: @values

  def equal?(a, b), do: a == b
end
