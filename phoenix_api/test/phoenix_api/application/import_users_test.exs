defmodule PhoenixApi.Application.ImportUsersTest do
  use PhoenixApi.DataCase, async: true

  alias PhoenixApi.Application.ImportUsers
  alias PhoenixApi.Domain.Users

  test "creates 100 users" do
    assert {:ok, _result} = ImportUsers.import_random_users()

    assert length(Users.list_users()) == 100
  end
end
