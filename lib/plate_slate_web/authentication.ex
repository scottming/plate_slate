defmodule PlateSlateWeb.Authentication do
  @user_salt "user salt"

  def sign(data) do
    Phoenix.Token.sign(PlateSlateWeb.Endpoint, @user_salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(PlateSlateWeb.Endpoint, @user_salt, token, max_age: 7 * 24 * 3600)
  end
end
