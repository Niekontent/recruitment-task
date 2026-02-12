defmodule PhoenixApi.Domain.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixApi.Domain.Users.Types.Gender

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :birthdate, :date
    field :gender, Gender

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :birthdate, :gender])
    |> validate_required(:gender)
  end
end
