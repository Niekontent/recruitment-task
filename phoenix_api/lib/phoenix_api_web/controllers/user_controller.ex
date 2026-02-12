defmodule PhoenixApiWeb.UserController do
  use PhoenixApiWeb, :controller

  alias PhoenixApi.Domain.Users

  def index(conn, _params) do
    users = Users.list_users()
    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    json(conn, user)
  end

  def create(conn, params) do
    with {:ok, user} <- Users.create_user(params) do
      json(conn, user)
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Users.get_user!(id)

    with {:ok, user} <- Users.update_user(user, params) do
      json(conn, user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, _} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
