module Redd
  module Clients
    class Base
      # Methods that require the "account" scope
      module Account
        # Edit some user preferences
        # @param [Hash] changed_prefs The preferences to override.
        # @return [Objects::Base] A Hashie-style container of the new prefs.
        # @see https://www.reddit.com/dev/api/oauth#PATCH_api_v1_me_prefs
        def edit_my_prefs(changed_prefs)
          response = connection.patch do |req|
            req.url "/api/v1/me/prefs"
            req.body = MultiJson.dump(changed_prefs)
          end
          
          Objects::Base.new(self, response.body)
        end
      end
    end
  end
end
