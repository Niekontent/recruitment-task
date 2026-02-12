defmodule PhoenixApi.Domain.UsersTest do
  use PhoenixApi.DataCase, async: true

  import PhoenixApi.Factory

  alias PhoenixApi.Domain.Users
  alias PhoenixApi.Domain.Users.User

  describe "list_users/0" do
    test "returns all users" do
      user = insert(:user)

      assert Users.list_users() == [user]
    end
  end

  describe "get_user!/1" do
    test "returns user by id" do
      user = insert(:user)

      assert Users.get_user!(user.id) == user
    end
  end

  describe "create_user/1" do
    test "creates user with valid data" do
      valid_attrs = %{
        first_name: "Jan",
        last_name: "Kowalski",
        birthdate: ~D[1990-01-01],
        gender: :male
      }

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.first_name == "Jan"
      assert user.gender == :male
    end

    test "returns error with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(%{first_name: nil})
    end
  end

  describe "update_user/2" do
    test "updates user with valid data" do
      user = insert(:user, first_name: "Adrian")

      assert {:ok, updated} = Users.update_user(user, %{first_name: "Adam"})
      assert updated.first_name == "Adam"
    end

    test "returns error with invalid data" do
      user = insert(:user, first_name: "Krystyna")

      assert {:error, %Ecto.Changeset{}} =
               Users.update_user(user, %{first_name: nil})

      assert Users.get_user!(user.id).first_name == "Krystyna"
    end
  end

  describe "delete_user/1" do
    test "deletes user" do
      user = insert(:user)

      assert {:ok, %User{}} = Users.delete_user(user)

      assert_raise Ecto.NoResultsError, fn ->
        Users.get_user!(user.id)
      end
    end
  end
end
