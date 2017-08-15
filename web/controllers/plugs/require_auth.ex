defmodule Discuss.Plugs.RequireAuth do
    import Plug.Conn
    import Phoenix.Controller
    
    alias Discuss.Router.Helpers
    
    # init is required
    def init(_params) do
    end

    # params is required, though we aren't really using here
    def call(conn, _params) do
        if conn.assigns[:user] do
            conn  # pass to next plug, etc
        else
            conn 
            |> put_flash(:error, "You must be logged in.")
            |> redirect(to: Helpers.topic_path(conn, :index))
            |> halt() # tells phoenix that conn is done
        end    
    end
end