defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User

    # just like all controllers, has conn and params args
    # bring conn in with pattern matching
    # To go through dev flow cycle after a user has been made, go to "authorized applications" in provider (github, etc), and revoke access *as a user* so that you can go through entire dev flow again, reauthorize the app.
    
    def callback( %{assigns: %{ueberauth_auth: auth}} = conn, params ) do       
        ## IO.inspect(auth)
        user_params = %{token: auth.credentials.token,
                        email: auth.info.email,
                        provider: "github"
                    }
        changeset = User.changeset(%User{}, user_params)
        
        signin(conn, changeset)
    end
    
    defp signin(conn, changeset) do
        case insert_or_update_user(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "Hi again!")
                |> put_session(:user_id, user.id) # like a cookie -- check Phoenix sessions
                |> redirect(to: topic_path(conn, :index))
            {:error, _reason} ->
                conn
                |> put_flash(:error, "Error Signing In")
                |> redirect(to: topic_path(conn, :index))
        end
    end

    def signout(conn, _params) do
        conn
        |> configure_session(drop: true)
        |> redirect(to: topic_path(conn, :index))
    end

    # https://hexdocs.pm/ecto/Ecto.Repo.html#c:get_by/3
    defp insert_or_update_user(changeset) do
        case Repo.get_by(User, email: changeset.changes.email)  do
            nil ->
                Repo.insert(changeset)
            user -> 
                {:ok, user}
        end
    end
end


# 74c1bc73e0f29ff7ff98c9da6f9c141b8a9f5d08