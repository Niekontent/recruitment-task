defmodule PhoenixApiWeb.UserController do
  use PhoenixApiWeb, :controller

  alias PhoenixApi.Domain.Users

  def index(conn, _params) do
    users = Users.list_users()
    json(conn, Enum.map(users, &user_to_map/1))
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      {:ok, user} -> json(conn, user_to_map(user))
      :error -> send_resp(conn, :not_found, "")
    end
  end

  def create(conn, params) do
    case Users.create_user(params) do
      {:ok, user} -> json(conn, user_to_map(user))
      {:error, changeset} -> unprocessable(conn, changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Users.get_user(id) do
      {:ok, user} ->
        case Users.update_user(user, params) do
          {:ok, user} -> json(conn, user_to_map(user))
          {:error, changeset} -> unprocessable(conn, changeset)
        end

      :error ->
        send_resp(conn, :not_found, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Users.get_user(id) do
      {:ok, user} ->
        case Users.delete_user(user) do
          {:ok, _} -> send_resp(conn, :no_content, "")
          {:error, _} -> send_resp(conn, :internal_server_error, "")
        end

      :error ->
        send_resp(conn, :not_found, "")
    end
  end

  # konwersja user -> mapa JSON
  defp user_to_map(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      birthdate: user.birthdate,
      gender: user.gender
    }
  end

  # helper do błędnych danych
  defp unprocessable(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)})
  end
end
