module Redd
  module Client
    class Unauthenticated
      module Account
        def login(username, password, remember = false)
          response = post "/api/login",
            api_type: "json", user: username, passwd: password, rem: remember
          data = response[:json][:data]

          require "redd/client/authenticated"
          Redd::Client::Authenticated.new(data[:cookie], data[:modhash])
        end
      end
    end
  end
end
