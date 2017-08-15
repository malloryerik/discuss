defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    alias Discuss.Topic  # shorten Discuss.Topic to Topic

    # require authentication for these actions
    plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :delete]

    # function plug
    plug :check_topic_owner when action in [:update, :edit, :delete]

    def index(conn, _params) do
                IO.inspect(conn.assigns)
        topics = Repo.all(Topic)
        # render some html, make available a list of topics
        render(conn, "index.html", topics: topics)  
    end

    def show(conn, %{"id" => topic_id}) do
           topic = Repo.get!(Topic, topic_id)
           render conn, "show.html", topic: topic

    end 

    def new(conn, params) do
        struct = %Topic{}
        params = %{}
        changeset = Topic.changeset(struct, params)

        render(conn, "new.html", changeset: changeset,)
    end

    def create(conn, params) do
        %{"topic" => topic} = params
        # conn.assigns[:user] -> get user, same as conn.assigns.user
        changeset = Topic.changeset(%Topic{}, topic) 

        changeset = conn.assigns[:user]
            |> build_assoc(:topics)
            |> Topic.changeset(topic)

        case Repo.insert(changeset) do
            # redirect user, send success msg
            {:ok, _topic} -> 
                conn
                |> put_flash(:info, "Topic Created")
                |> redirect(to: topic_path(conn, :index))

            {:error, changeset} -> IO.inspect(changeset) 
                render conn, "new.html", changeset: changeset
        end
    end

    def edit(conn, %{"id" => topic_id}) do  # "id" matches :id in route
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end

    def update(conn, %{ "id" => topic_id, "topic" => topic }) do
        old_topic = Repo.get(Topic, topic_id)
        changeset =  Topic.changeset(old_topic, topic)

        case Repo.update(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: topic_path(conn, :index))

            {:error, changeset} ->
                render(conn, "edit.html", changeset: changeset, topic: old_topic)
        end   
    end

    def delete(conn, %{ "id" => topic_id}) do
        Repo.get!(Topic, topic_id) |> Repo.delete! 
            conn
            |> put_flash(:info, "Topic Deleted")
            |> redirect(to: topic_path(conn, :index))

    end

        # plugs are different
    defp check_topic_owner(conn, _p) do
        %{params: %{"id" => topic_id}} = conn

        if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
            conn
        else
            conn
            |> put_flash(:error, "You can't edit that")
            |> redirect(to: topic_path(conn, :index))
            |> halt()
        end

    end
end