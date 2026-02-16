defmodule PhoenixApiWeb.UserControllerTest do
  use PhoenixApiWeb.ConnCase, async: true

  import PhoenixApi.Factory

  alias PhoenixApi.Domain.Users
  alias PhoenixApi.Domain.Users.User

  @valid_attrs %{
    "first_name" => "Wanda",
    "last_name" => "Maximoff",
    "birthdate" => "1989-02-10",
    "gender" => "female"
  }

  @invalid_attrs %{
    "first_name" => nil
  }

  describe "index/2" do
    test "returns list of users", %{conn: conn} do
      _user = insert(:user)

      conn = get(conn, "/api/users")

      assert json_response(conn, 200) |> length() == 1
    end
  end

  describe "show/2" do
    test "returns single user", %{conn: conn} do
      user = insert(:user)

      conn = get(conn, "/api/users/#{user.id}")

      assert json_response(conn, 200)["id"] == user.id
    end

    test "returns error for invalid ID", %{conn: conn} do
      conn = get(conn, "/api/users/1234")

      assert response(conn, 404)
    end
  end

  describe "create/2" do
    test "creates user with valid data", %{conn: conn} do
      conn = post(conn, "/api/users", @valid_attrs)

      assert json_response(conn, 200)["first_name"] == "Wanda"
    end

    test "returns error with invalid data", %{conn: conn} do
      conn = post(conn, "/api/users", @invalid_attrs)

      assert conn.status == 422
      assert %{"errors" => _} = json_response(conn, 422)
    end
  end

  describe "update/2" do
    test "updates user", %{conn: conn} do
      user = insert(:user)

      conn =
        put(conn, "/api/users/#{user.id}", %{
          "first_name" => "Elizabeth"
        })

      assert json_response(conn, 200)["first_name"] == "Elizabeth"
    end
  end

  describe "delete/2" do
    test "deletes user", %{conn: conn} do
      user = insert(:user)

      conn = delete(conn, "/api/users/#{user.id}")

      assert response(conn, 204)

      assert :error == Users.get_user(user.id)
    end
  end
end
