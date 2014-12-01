module Redd
  module Client
    class Authenticated
      # Methods to interact with subreddits
      module Subreddits
        # Subscribe to a subreddit.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   subscribe to.
        def subscribe(subreddit)
          edit_subscription(:sub, subreddit)
        end

        # Unsubscribe from a subreddit.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   unsubscribe from.
        def unsubscribe(subreddit)
          edit_subscription(:unsub, subreddit)
        end

        # Get a listing of subreddits.
        #
        # @param where [:popular, :new, :subscriber, :contributor, :moderator]
        #   The order of subreddits to return.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @return [Redd::Object::Listing] A listing of subreddits.
        def get_subreddits(where = :subscriber, params = {})
          path =
            if [:popular, :new].include?(where)
              "/subreddits/#{where}.json"
            elsif [:subscriber, :contributor, :moderator].include?(where)
              "/subreddits/mine/#{where}.json"
            end
          object_from_response(:get, path, params)
        end

        # Get users related to the subreddit.
        #
        # @param where [:banned, :wikibanned, :contributors, :wikicontributors,
        #   :moderators] The order of users to return.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit.
        #   The order of subreddits to return.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @return [Redd::Object::Listing] A listing of users.
        # @note On reddit's end, this is actually a UserList, which is slightly
        #   different to a real listing, since it only provides names and ids.
        def get_special_users(where, subreddit, params = {})
          name = extract_attribute(subreddit, :display_name)
          response = get "/r/#{name}/about/#{where}.json", params

          things = response[:data][:children].map! do |user|
            object_from_body(kind: "t2", data: user)
          end
          Redd::Object::Listing.new(data: {children: things})
        end

        # Edit Subreddit's stylesheet
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   submit.
        # @param contents [String] css
        # @param reason [String]
        # @note https://www.reddit.com/r/***/about/stylesheet/ is good place
        #   to test if  you have an error
        def edit_stylesheet(subreddit, contents, reason = nil)
          name = extract_attribute(subreddit, :display_name)
          path = "/r/#{name}/api/subreddit_stylesheet"
          params = {
            api_type: "json",
            op: "save",
            stylesheet_contents: contents
          }
          params[:reason] = reason if reason
          post path, params
        end

        # Edit Subreddit's settings
        #
        # @param attrs [Hash] Settings for subrredit
        # @note these links might useful: https://www.reddit.com/dev/api and
        #   https://github.com/alaycock/MeetCal-bot/blob/master/serverInfo.conf
        def site_admin(attrs)
          path = "/api/site_admin"
          params = {
            allow_top: nil,                 # boolean
            api_type: "json",               # always "json"
            collapse_deleted_comments: nil, # boolean
            comment_score_hide_mins: nil,   # int 0..1440 def: 0
            css_on_cname: nil,              # boolean
            description: nil,               # markdown string
            exclude_banned_modqueue: nil,   # boolean
            lang: nil,                      # valid IETF lang tag, eg: en
            link_type: nil,                 # string [any, link, self]
            name: nil,                      # string subreddit name
            over_18: nil,                   # boolean
            public_description: nil,        # markdown string
            public_traffic: nil,            # boolean
            show_cname_sidebar: nil,        # boolean
            show_media: nil,                # boolean
            spam_comments: nil,             # string [low, high, all]
            spam_links: nil,                # string [low, high, all]
            spam_selfposts: nil,            # string [low, high, all]
            sr: nil,                        # string, for subreddit it should start like "t5_"
            submit_link_label: nil,         # string max 60 chars
            submit_text: nil,               # markdown string
            submit_text_label: nil,         # string max 60 chars
            title: nil,                     # string max 100 chars
            type: nil,                      # string [public, private, restricted, gold_restricted, archived]
            wiki_edit_age: nil,             # int 0+, def: 0
            wiki_edit_karma: nil,           # int 0+, def: 0
            wikimode: nil                   # string [disabled, modonly, anyone]
          }
          params["header-title"] = ''       # string max 500 chars

          params.keys.each{|key|
            if !attrs[key].nil?
              params[key] = attrs[key]
            end
          }

          empties = params.map{ |obj|
            obj.last.nil? ? obj.first.to_s : nil
          }
          empties = empties.reject!{ |elm| elm.nil? }
          if !empties.empty?
            raise "The following item should not be nil => [" + empties.join(', ') + ']'
          end

          post path, params
        end

        # Get the current settings of a subreddit.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   submit.
        def about_edit(subreddit)
          name = extract_attribute(subreddit, :display_name)
          object_from_response :get, "/r/#{name}/about/edit.json"
        end

        private

        # Subscribe or unsubscribe to a subreddit.
        #
        # @param action [:sub, :unsub] The type of action to perform.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   perform the action on.
        def edit_subscription(action, subreddit)
          fullname = extract_fullname(subreddit)
          post "/api/subscribe", action: action, sr: fullname
        end
      end
    end
  end
end
