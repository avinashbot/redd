require "redd/client/unauthenticated"
require "redd/client/authenticated"
require "redd/client/oauth2"

module Redd
  def self.client(username = nil, password = nil)
    client = Redd::Client::Unauthenticated.new
    if username.nil? || password.nil?
      client
    else
      client.login(username, password)
    end
  end
end
