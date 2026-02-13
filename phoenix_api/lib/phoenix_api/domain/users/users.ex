defmodule PhoenixApi.Domain.Users do
  alias PhoenixApi.Repo
  alias PhoenixApi.Domain.Users.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(user) do
    Repo.delete(user)
  end

  def random_user(male_first_names, female_first_names, male_last_names, female_last_names) do
    gender = if :rand.uniform() > 0.5, do: :male, else: :female

    first_name =
      if gender == :male, do: Enum.random(male_first_names), else: Enum.random(female_first_names)

    last_name = Enum.random(male_last_names ++ female_last_names)
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
