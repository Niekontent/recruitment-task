defmodule PhoenixApiWeb.ImportController do
  use PhoenixApiWeb, :controller
  alias PhoenixApi.Application.ImportUsers

  plug :authorize_api_token when action in [:import]

  def import(conn, _params) do
    service().import_random_users()
    json(conn, %{status: "ok"})
  end

  defp authorize_api_token(conn, _opts) do
    token = get_req_header(conn, "authorization") |> List.first()

    if token == "VERY_SECRET_TOKEN" do
      conn
    else
      conn
      |> send_resp(401, "unauthorized")
      |> halt()
    end
  end

  defp service do
    Application.get_env(:phoenix_api, :import_users, ImportUsers)
  end
end
