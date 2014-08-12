require "redd/client/unauthenticated"
require "redd/client/authenticated"
require "redd/client/oauth2"

# The Redd module
module Redd
  def self.client(user = nil, pass = nil, redirect_uri = nil, opts = {})
    if redirect_uri
      Redd::Client::OAuth2.new(user, pass, redirect_uri, opts)
    elsif user && pass
      Redd::Client::Authenticated.new_from_credentials(user, pass, opts)
    else
      Redd::Client::Unauthenticated.new
    end
  end
end
