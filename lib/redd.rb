require "redd/client/unauthenticated"
require "redd/client/authenticated"
require "redd/client/oauth2"

module Redd
  def self.client(username = nil, password = nil, redirect_uri = nil, options = {})
    if redirect_uri
      Redd::Client::OAuth2.new(username, password, redirect_uri, options)
    elsif username && password
      Redd::Client::Authenticated.new_from_credentials(username, password, options)
    else
      Redd::Client::Unauthenticated.new
    end
  end
end
