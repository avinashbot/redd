module Redd
  module Client
    class Unauthenticated
      module Account
        def login(username, password, remember = false)
          meth = :post
          path = "/api/login"
          params = {
            api_type: "json", user: username,
            passwd: password, rem: remember
          }
          response = send(meth, path, params)
          data = response.body[:json][:data]

          require "redd/client/authenticated"
          Redd::Client::Authenticated.new(data[:cookie], data[:modhash])
        end
      end
    end
  end
end
