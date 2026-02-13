defmodule PhoenixApiWeb.Router do
  use PhoenixApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixApiWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end

  post "/import", PhoenixApiWeb.ImportController, :import
end
