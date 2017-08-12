defmodule Discuss.User do
    use Discuss.Web, :model
    
    schema "users" do
        field :email, :string
        field :provider, :string
        field :token, :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do  # `\\ %{}` initiated with empty map
        struct
        |> cast(params, [:email, :provider, :token])        # create a changeset
        |> validate_required([:email, :provider, :token])   # users must have these
    end
end