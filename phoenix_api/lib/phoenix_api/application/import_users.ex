defmodule PhoenixApi.Application.ImportUsers do
  alias PhoenixApi.Infra.CSVReader
  alias PhoenixApi.Domain.Users
  alias PhoenixApi.Repo

  @callback import_random_users() :: any()

  @moduledoc """
  Use case: Import of random users from CSV files.

  - Feteches first 100 records (ignoring header) from each CSV file
  - Generates 100 random users
  - Saves them into databse throgh the domain (Users.create_user/1)
  """

  @user_count 100

  def import_random_users do
    male_first_names = CSVReader.read("male_names.csv")
    female_first_names = CSVReader.read("female_names.csv")
    male_last_names = CSVReader.read("male_surnames.csv")
    female_last_names = CSVReader.read("female_surnames.csv")

    Repo.transaction(fn ->
      1..@user_count
      |> Enum.each(fn _ ->
        user =
          Users.random_user(
            male_first_names,
            female_first_names,
            male_last_names,
            female_last_names
          )

        case Users.create_user(Map.from_struct(user)) do
          {:ok, _user} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      end)
    end)
  end
end
