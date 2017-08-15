defmodule Discuss.Topic do
    use Discuss.Web, :model

    schema("topics") do
        field :title, :string
        belongs_to :user, Discuss.User # shows that every topic has a user from the Discuss.User table in postgres
        has_many :comments, Discuss.Comment

        timestamps()
    end

    def changeset(struct, params \\ %{}) do    
        struct
        |> cast(params, [:title]) #produce & return changeset -- "the 'magic' spot"
        |> validate_required([:title]) #inspect, judge, returns a "changeset"
    end
end