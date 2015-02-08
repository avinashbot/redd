require_relative "redd/version"
require_relative "redd/clients/installed"
require_relative "redd/clients/script"
require_relative "redd/clients/userless"
require_relative "redd/clients/web"

# The main Redd module.
module Redd
  # @overload it(:installed, client_id, redirect_uri, **kwargs)
  #   Authorize a user via an installed app.
  #   @param [String] client_id The client ID provided by reddit.
  #   @param [String] redirect_uri The exact uri you provided to reddit.
  #   @param [Hash] kwargs The keyword arguments provided to the client.
  #
  # @overload it(:script, client_id, secret, username, password, **kwargs)
  #   Authorize a user that you have full access to, i.e. a bot.
  #   @param [String] client_id The client ID provided by reddit.
  #   @param [String] secret The client secret provided by reddit.
  #   @param [String] username The username.
  #   @param [String] password The password of the user.
  #   @param [Hash] kwargs The keyword arguments provided to the client.
  #
  # @overload it(:userless, client_id, secret, **kwargs)
  #   Connect to reddit from a web-app or a script without a specific user.
  #   @param [String] client_id The client ID provided by reddit.
  #   @param [String] secret The client secret provided by reddit.
  #   @param [Hash] kwargs The keyword arguments provided to the client.
  #
  # @overload it(:web, client_id, secret, redirect_uri, **kwargs)
  #   Authorize a user from a website.
  #   @param [String] client_id The client ID provided by reddit.
  #   @param [String] secret The client secret provided by reddit.
  #   @param [String] redirect_uri The exact uri you provided to reddit.
  #   @param [Hash] kwargs The keyword arguments provided to the client.
  #
  # @return [Clients::Base] The authorized client.
  def self.it(type, *args, **kwargs)
    types = {
      installed: Clients::Installed,
      script: Clients::Script,
      userless: Clients::Userless,
      web: Clients::Web
    }

    @client = types[type].new(*args, **kwargs)
  end
end
