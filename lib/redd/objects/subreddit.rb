require "fastimage"
require_relative "thing"

module Redd
  module Objects
    # A comment made on links.
    # @todo #subscribe! and #unsubscribe!
    class Subreddit < Thing
      include Thing::Messageable
      include Thing::Refreshable

      alias_property :header_image, :header_img
      alias_property :nsfw?, :over18
      alias_property :users_online, :accounts_active
      alias_property :type, :subreddit_type
      alias_property :times_gilded, :gilded

      # @!group Stylesheets

      # @return [String] The url for the subreddit's stylesheet.
      def stylesheet_url
        get("/r/#{display_name}/stylesheet").headers["location"]
      end

      # @return [String] The css for the subreddit.
      def stylesheet
        Faraday.get(stylesheet_url).body
      end

      # Edit the subreddit's stylesheet
      #
      # @param [String] contents The new CSS.
      # @param [String] reason Why you modified the stylesheet.
      # @author Takashi M (@beatak) and Avinash Dwarapu (@avidw)
      # @note https://www.reddit.com/r/naut/about/stylesheet/ is a good place
      #   to test if you have an error.
      def edit_stylesheet(contents, reason = nil)
        params = {op: "save", stylesheet_contents: contents}
        params[:reason] = reason if reason
        post("/r/#{display_name}/api/subreddit_stylesheet", params)
      end

      # @!endgroup

      # @!group Invites

      # Accept a moderator invite from a subreddit.
      def accept_moderator_invite!
        post("/r/#{display_name}/api/accept_moderator_invite")
      end

      # Stop being a contributor of the subreddit.
      def leave_contributor_status!
        post("/api/leavecontributor", id: fullname)
      end

      # Stop being a moderator of the subreddit.
      def leave_moderator_status!
        post("/api/leavemoderator", id: fullname)
      end

      # @!endgroup

      # @!group Flairs

      # Get a list of everbody on the subreddit with a user flair.
      #
      # @param [Hash] params A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String] :before Return results before the given
      #   fullname.
      # @option params [Integer] :count The number of items already seen in the
      #   listing.
      # @option params [1..1000] :limit The maximum number of things to
      #   return.
      # @option params [String] :name The username when getting the flair of
      #   just one user.
      # @return [Objects::Listing<Hash>] A listing of flair hashes.
      def get_flairlist(**params)
        body = get("/r/#{display_name}/api/flairlist.json", params).body
        client.object_from_body(
          kind: "Listing",
          data: {
            children: body[:users],
            before: body[:prev],
            after: body[:next]
          }
        )
      end

      # Get the flair of a user.
      #
      # @param [Objects::User, String] user The user to find.
      # @return [Hash, nil] Flair info about the user or nil if nobody was
      #   found.
      def get_flair(user)
        username = client.property(user, :name)
        flair = get_flairlist(user: username).first
        flair if flair[:user].casecmp(username) == 0
      end

      # Set the flair of a user or link.
      # @param [Objects::Subreddit, Objects::User] thing The user or link to
      #   set the flair to.
      # @param [:user, :link] type The type of thing.
      # @param [String] text The text to set the flair to.
      # @param [String] css_class The css_class of the flair.
      def set_flair(thing, type = nil, text = nil, css_class = nil)
        if thing.is_a?(Objects::User) || type == :user
          params[:name] = client.property(thing, :name)
        elsif thing.is_a?(Objects::Submission) || type == :user
          params[:link] = client.property(thing, :fullname)
        else
          fail "You should provide a proper type."
        end

        post("/r/#{display_name}/api/flair", text: text, css_class: css_class)
      end

      # @!endgroup

      # @!group Listings

      # @!method get_hot(**params)
      # @!method get_new(**params)
      # @!method get_top(**params)
      # @!method get_controversial(**params)
      # @!method get_comments(**params)
      #
      # Get the appropriate listing.
      # @param params [Hash] A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String :before Return results before the given
      #   fullname.
      # @option params [Integer] :count (0) The number of items already seen
      #   in the listing.
      # @option params [1..100] :limit (25) The maximum number of things to
      #   return.
      # @option params [:hour, :day, :week, :month, :year, :all] :t The
      #   time period to consider when sorting.
      #
      # @note The option :t only applies to the top and controversial sorts.
      # @return [Objects::Listing<Objects::Thing>]
      %w(hot new top controversial comments).each do |sort|
        define_method :"get_#{sort}" do |**params|
          client.send(:"get_#{sort}", self, **params)
        end
      end

      # Search.
      # @param query [String] The query string.
      # @param params [Hash] A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String :before Return results before the given
      #   fullname.
      # @option params [Integer] :count The number of items already seen in
      #   the listing.
      # @option params [1..100] :limit The maximum number of things to
      #   return.
      # @option params [:cloudsearch, :lucene, :plain] :syntax The type of
      #   syntax to use.
      # @option params [:relevance, :new, :hot, :top, :comments] :sort The
      #   way to sort the results.
      # @option params [:hour, :day, :week, :month, :year, :all] :t The
      #   time period to consider when sorting.
      #
      # @note The option :t only applies to the top and controversial sorts.
      # @return [Objects::Listing<Objects::Thing>]
      def search(query, **params)
        client.search(query, self, **params)
      end

      # @!method get_reports(**params)
      # @!method get_spam(**params)
      # @!method get_modqueue(**params)
      # @!method get_unmoderated(**params)
      # @!method get_edited(**params)
      #
      # Get the appropriate moderator listing.
      # @param [Hash] params A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String] :before Return results before the given
      #   fullname.
      # @option params [Integer] :count The number of items already seen
      #   in the listing.
      # @option params [1..100] :limit The maximum number of things to
      #   return.
      # @option params :location No idea what this does.
      # @option params [:links, :comments] :only The type of things to show.
      #
      # @return [Objects::Listing<Objects::Thing>]
      # @see https://www.reddit.com/dev/api#GET_about_{location}
      %w(reports spam modqueue unmoderated edited).each do |sort|
        define_method :"get_#{sort}" do |**params|
          client.request_object(
            :get, "/r/#{display_name}/about/#{sort}", params
          )
        end
      end

      # @!endgroup

      # @!group Moderator Settings

      # @return [Objects::Base] The current settings of a subreddit.
      def admin_about
        client.request_object(:get, "/r/#{display_name}/about/edit.json")
      end

      # Edit the subreddit's settings
      # @param [Hash] attributes The subreddit's new settings.
      # @author Takashi M (@beatak) and Avinash Dwarapu (@avidw)
      # @note This method may make additional requests if not all of the
      #   required attributes are provided.
      # @see https://github.com/alaycock/MeetCal-bot/blob/master/serverInfo.conf
      def admin_edit(attributes)
        params = {sr: fullname}
        required_attributes = %i(
          allow_top collapse_deleted_comments comment_score_hide_mins
          css_on_cname description exclude_banned_modqueue lang name over_18
          public_description public_traffic show_cname_sidebar show_media
          spam_comments spam_links spam_selfposts submit_link_label
          submit_text submit_text_label title type wiki_edit_age
          wiki_edit_karma wikimode header-title
        )

        if required_attributes.all? { |key| attributes.key?(key) }
          params.merge!(attributes)
        else
          current = admin_about
          current.delete(:kind)
          complete = current.merge(attributes)
          params.merge!(complete)
        end

        post("/api/site_admin", params)
      end

      # Add or replace the subreddit image or header logo.
      # @param [String, IO] file The path/url to the file or the file itself.
      # @param [String] name The name of the uploaded file.
      # @param [Boolean] header Whether the image should be set as the
      #   subreddit header.
      # @return [String] The url of the image on reddit's CDN.
      def upload_image(file, name = nil, header = true)
        fail "You can't set name and also enable header!" if name && header
        
        io = (file.is_a?(IO) ? file : File.open(file, "r"))
        type = FastImage.type(io)
        payload = Faraday::UploadIO.new(io, "image/#{type}")

        params = {file: payload, header: (header ? 1 : 0), img_type: type}
        params[:name] = name if name
        post("/r/#{display_name}/api/upload_sr_img", params).body[:img_src]
      end

      # @!endgroup
    end
  end
end
