# ---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
# ---
defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema
  alias PlateSlateWeb.Resolvers
  alias PlateSlateWeb.Schema.Middleware

  def middleware(middleware, field, %{identifier: :allergy_info} = object) do
    new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}
    middleware |> Absinthe.Schema.replace_default(new_middleware, field, object)
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  import_types __MODULE__.MenuTypes
  import_types __MODULE__.OrderingTypes
  import_types __MODULE__.AccountsTypes

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    @desc "Search category or item"
    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end
  end

  mutation do
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :role, non_null(:role)
      resolve &Resolvers.Accounts.login/3

      middleware(fn res, _ ->
        with %{value: %{user: user}} <- res do
          %{res | context: Map.put(res.context, :current_user, user)}
        end
      end)
    end

    field :place_order, :order_result do
      arg :input, non_null(:place_order_input)
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Ordering.place_order/3
    end

    field :ready_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.ready_order/3
    end

    field :complete_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.complete_order/3
    end

    field :create_menu_item, :menu_item_result do
      arg :input, non_null(:menu_item_input)
      middleware Middleware.Authorize, "employee"
      resolve &Resolvers.Menu.create_item/3
    end
  end

  subscription do
    field :new_order, :order do
      config fn _args, %{context: context} ->
        case context[:current_user] do
          %{role: "customer", id: id} ->
            {:ok, topic: id}

          %{role: "employee"} ->
            {:ok, topic: "*"}

          _ ->
            {:error, "unauthorized"}
        end
      end
    end

    field :update_order, :order do
      arg :id, non_null(:id)
      config fn args, _info -> {:ok, topic: args.id} end

      trigger [:ready_order, :complete_order],
        topic: fn
          %{order: order} -> [order.id]
          _ -> []
        end

      resolve fn %{order: order}, _, _ -> {:ok, order} end
    end
  end

  scalar :date do
    parse(fn input ->
      case Date.from_iso8601(input.value) do
        {:ok, date} -> {:ok, date}
        _ -> :error
      end
    end)

    serialize(fn date ->
      Date.to_iso8601(date)
    end)
  end

  scalar :decimal do
    parse fn
      %{value: value}, _ -> Decimal.parse(value)
      _, _ -> :error
    end

    serialize &to_string/1
  end

  enum :sort_order do
    value :asc
    value :desc
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end
end
