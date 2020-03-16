# ---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
# ---
defmodule PlateSlateWeb.Schema.Mutation.CreateMenuReturnsPayloadTest do
  use PlateSlateWeb.ConnCase, async: true

  alias PlateSlate.{Repo, Menu}
  import Ecto.Query

  setup do
    PlateSlate.Seeds.run()

    category_id =
      from(t in Menu.Category, where: t.name == "Sandwiches")
      |> Repo.one!()
      |> Map.fetch!(:id)
      |> to_string

    {:ok, category_id: category_id}
  end

  defp auth_user(conn, user) do
    token = PlateSlateWeb.Authentication.sign(%{role: user.role, id: user.id})
    put_req_header(conn, "authorization", "Bearer #{token}")
  end

  @query1 """
  mutation ($menuItem: MenuItemInput!) {
    createMenuItem(input: $menuItem) {
      successful
      messages { code message }
      result {
        name
        description
        price
      }
    }
  }
  """
  test "creating a menu item with an existing name fails",
       %{category_id: category_id} do
    menu_item = %{
      "name" => "Reuben",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id
    }

    user = Factory.create_user("employee")
    conn = build_conn() |> auth_user(user)

    conn =
      post conn, "/api",
        query: @query1,
        variables: %{"menuItem" => menu_item}

    assert %{"data" => %{"createMenuItem" => %{"successful" => false}}} = json_response(conn, 200)
  end

  @query2 """
  mutation ($menuItem: MenuItemInput!) {
    createMenuItemManual(input: $menuItem) {
      successful
      messages { code message }
      result {
        name
        description
        price
      }
    }
  }
  """
  test "creating a menu item with an existing name fails again.",
       %{category_id: category_id} do
    menu_item = %{
      "name" => "Reuben",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id
    }

    user = Factory.create_user("employee")
    conn = build_conn() |> auth_user(user)

    conn =
      post conn, "/api",
        query: @query2,
        variables: %{"menuItem" => menu_item}

    assert %{"data" => %{"createMenuItemManual" => %{"successful" => false}}} =
             json_response(conn, 200)
  end
end
