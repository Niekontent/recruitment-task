defmodule PhoenixApi.Factory do
  use ExMachina.Ecto, repo: PhoenixApi.Repo

  alias PhoenixApi.Domain.Users.User

  def user_factory do
    %User{
      first_name: "Wanda",
      last_name: "Maximoff",
      birthdate: ~D[1989-02-10],
      gender: :female
    }
  end
end
