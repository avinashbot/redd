module Redd
  module Client
    class Authenticated
      # Methods to interact with link and user flairs.
      module Flair
        # Get a list of everbody on the subreddit with a user flair.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   find the users in.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..1000] :limit (25) The maximum number of things to
        #   return.
        # @option params [:hour, :day, :week, :month, :year, :all] :t The
        #   time period to consider when sorting.
        # @return [Array<Hash>] An array of users.
        def get_flair_list(subreddit, params = {})
          name = extract_attribute(subreddit, :display_name)

          path = "/api/flairlist.json"
          path = path.prepend("/r/#{name}")

          get(path, params)[:users]
        end

        # Get the flair of a user.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   find the user in.
        # @param subreddit [Redd::Object::User, String] The user to find.
        # @return [Hash, nil] Flair info about the user or nil if nobody was
        #   found.
        def get_flair(subreddit, user)
          display_name = extract_attribute(subreddit, :display_name)
          username = extract_attribute(user, :name)
          options = {name: username}

          flair = get_flair_list(display_name, options).first
          flair if flair[:user].casecmp(username.downcase) == 0
        end

        # Set the flair of a user or link.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   find the user in.
        # @param user_or_link [Redd::Object::Subreddit, Redd::Object::User]
        #   The user or link to set the flair to.
        # @param text [String] The text to set the flair to.
        # @param css_class [String] The css_class of the flair.
        def set_flair(subreddit, user_or_link, text = "", css_class = "")
          name = extract_attribute(subreddit, :display_name)
          path = "/r/#{name}/api/flair"

          case user_or_link
          when Redd::Object::User
            params[:name] = extract_attribute(user_or_link, :name)
          when Redd::Object::Submission
            params[:link] = extract_attribute(user_or_link, :display_name)
          else
            fail "You should provide a User or Submission object."
          end

          post path, api_type: "json", text: text, css_class: css_class
        end
      end
    end
  end
end
