defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  
  end

  scope "/", Discuss do
    pipe_through :browser      # Use the default browser stack

    get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit # :id is a wildcard matcher
    # put "/topics/:id", TopicController, :update
    # show  - just the topic's id number after "/topics/"
    resources "/topics", TopicController
  end

  scope "/auth", Discuss do     # collection of routes all prefixed with `/auth`
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request         # `:request` is defined by Ueberauth
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
