defmodule Discuss.Topic do
    use Discuss.Web, :model

    schema("topics") do
        field :title, :string
    end

    def changeset(struct, params \\ %{}) do    
        struct
        |> cast(params, [:title]) #produce & return changeset -- "the 'magic' spot"
        |> validate_required([:title]) #inspect, judge, returns a "changeset"
    end
end