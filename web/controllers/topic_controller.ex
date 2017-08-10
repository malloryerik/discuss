defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    alias Discuss.Topic  # shorten Discuss.Topic to Topic

    def index(conn, _params) do
        topics = Repo.all(Topic)
        # render some html, make available a list of topics
        render(conn, "index.html", topics: topics)  
    end

    def new(conn, params) do
        struct = %Topic{}
        params = %{}
        changeset = Topic.changeset(struct, params)

        render(conn, "new.html", changeset: changeset,)
    end

    def create(conn, params) do
        %{"topic" => topic} = params
        changeset = Topic.changeset(%Topic{}, topic)

        case Repo.insert(changeset) do
            # redirect user, send success msg
            {:ok, topic} -> 
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
end