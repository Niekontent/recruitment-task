defmodule PhoenixApi.Domain.Users do
  @moduledoc """
  Users domain context.

  Provides CRUD operations and query utilities for `User` entities.
  Acts as a boundary between controllers and persistence layer.
  """

  alias PhoenixApi.Repo
  alias PhoenixApi.Domain.Users.User
  alias PhoenixApi.Domain.Users.UserQueries

  @doc """
  Returns a list of users.

  Accepts optional filtering and sorting params
  (e.g. from controller `conn.params`).
  """
  @spec list_users(map()) :: [User.t()]
  def list_users(params \\ %{}) do
    User
    |> UserQueries.filter(params)
    |> UserQueries.sort(params)
    |> Repo.all()
  end

  @doc """
  Returns a user by id.

  Raises `Ecto.NoResultsError` if user does not exist.
  """
  @spec get_user!(pos_integer()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Returns a user by id.

  Returns:
    * `{:ok, user}` when found
    * `:error` when not found
  """
  @spec get_user(pos_integer()) :: {:ok, User.t()} | :error
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> :error
      user -> {:ok, user}
    end
  end

  @doc """
  Creates user.

  Returns:
    * `{:ok, user}` when created
    * `{:error, changeset}` when not created
  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates user.

  Returns:
    * `{:ok, user}` when updated
    * `{:error, changeset}` when not updated
  """
  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes user.

  Returns:
    * `{:ok, user}` when deleted
    * `{:error, changeset}` when not deleted
  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(user) do
    Repo.delete(user)
  end

  @doc """
  Helper function generating User struct.
  Accepts names and lats names lists.
  """
  @spec random_user([String.t()], [String.t()], [String.t()], [String.t()]) :: User.t()
  def random_user(male_first_names, female_first_names, male_last_names, female_last_names) do
    gender = if :rand.uniform() > 0.5, do: :male, else: :female

    first_name =
      if gender == :male, do: Enum.random(male_first_names), else: Enum.random(female_first_names)

    last_name =
      if gender == :male, do: Enum.random(male_last_names), else: Enum.random(female_last_names)

    birthdate = random_date(~D[1970-01-01], ~D[2024-12-31])

    %User{
      first_name: first_name,
      last_name: last_name,
      gender: gender,
      birthdate: birthdate
    }
  end

  defp random_date(start, finish) do
    Date.add(start, :rand.uniform(Date.diff(finish, start)))
  end
end
