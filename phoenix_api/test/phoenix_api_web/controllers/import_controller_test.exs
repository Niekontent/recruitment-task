defmodule PhoenixApiWeb.ImportControllerTest do
  use PhoenixApiWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  @token "VERY_SECRET_TOKEN"

  test "returns 401 without token", %{conn: conn} do
    conn = post(conn, "/import")

    assert response(conn, 401)
  end

  test "returns 401 with invalid token", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "BAD")
      |> post("/import")

    assert response(conn, 401)
  end

  test "calls import and returns ok when token is valid", %{conn: conn} do
    PhoenixApi.Application.ImportUsersMock
    |> expect(:import_random_users, fn ->
      :ok
    end)

    conn =
      conn
      |> put_req_header("authorization", @token)
      |> post("/import")

    assert json_response(conn, 200) == %{"status" => "ok"}
  end
end
