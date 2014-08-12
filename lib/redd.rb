require "redd/client/unauthenticated"
require "redd/client/authenticated"
require "redd/client/oauth2"

# The Redd module.
module Redd
  # Guess which client to create based on the arguments given.
  # 
  # @param user [String] The username to login with.
  # @param pass [String] The password to login with.
  # @param redirect_uri [String] The redirect url for OAuth2.
  # @param opts [Hash] Options to pass on to the client.
  def self.client(user = nil, pass = nil, redirect_uri = nil, opts = {})
    if redirect_uri
      Redd::Client::OAuth2.new(user, pass, redirect_uri, opts)
    elsif user && pass
      Redd::Client::Authenticated.new_from_credentials(user, pass, opts)
    else
      Redd::Client::Unauthenticated.new(opts)
    end
  end
end
