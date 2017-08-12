# Make a module plug called `Discuss.Plugs.SetUser`
defmodule Discuss.Plugs.SetUser do
    import Plug.Conn           # for `assign`
    import Phoenix.Controller  # for `get_session`

    alias Discuss.Repo
    alias Discuss.User

    def init(_params) do 
    end

    def call(conn, _params) do
        user_id = get_session(conn, :user_id) # `get_session` is from `Phoenix.Controller` 
        # unset get_session to log out users
        cond do
            # if return a user and user_id exists, 
            # remember that in Elixir booleans, `&&` returns the last value, `Repo.get(...)`
            user = user_id && Repo.get(User, user_id) ->
                assign(conn, :user, user) 
                    # `conn.assigns.user => user struct from db
                    # note: function is `assign`, but the data is `assigns`

            # if all else fails, do this
            true ->
                assign(conn, :user, nil)
        end
    end
end