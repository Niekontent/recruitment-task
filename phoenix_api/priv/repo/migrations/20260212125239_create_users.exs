defmodule PhoenixApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :birthdate, :date
      add :gender, :string, null: false

      timestamps()
    end

    create constraint(:users, :gender_must_be_valid,
             check: "gender in ('male', 'female')"
           )
  end
end
