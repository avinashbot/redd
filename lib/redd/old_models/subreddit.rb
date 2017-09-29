# frozen_string_literal: true

require_relative 'basic_model'
require_relative 'lazy_model'
require_relative 'messageable'
require_relative 'searchable'
require_relative '../utilities/stream'

module Redd
  module Models
    # A subreddit.
    class Subreddit < LazyModel
      include Messageable
      include Searchable

      # A mapping from keys returned by #settings to keys required by #modify_settings
      SETTINGS_MAP = {
        subreddit_type: :type,
        language: :lang,
        content_options: :link_type,
        default_set: :allow_top,
        header_hover_text: :'header-title'
      }

      # Represents a moderator action, part of a moderation log.
      # @see Subreddit#log
      class ModAction < BasicModel; end

      # Create a Subreddit from its name.
      # @param client [APIClient] the api client to initialize the object with
      # @param id [String] the subreddit name
      # @return [Subreddit]
      def self.from_id(client, id)
        new(client, display_name: id)
      end

      # @return [Array<String>] the subreddit's wiki pages
      def wiki_pages
        @client.get("/r/#{get_attribute(:display_name)}/wiki/pages").body[:data]
      end

      # Get a wiki page by its title.
      # @param title [String] the page's title
      # @return [WikiPage]
      def wiki_page(title)
        WikiPage.new(@client, title: title, subreddit: self)
      end

      # Search a subreddit.
      # @param query [String] the search query
      # @param params [Hash] refer to {Searchable} to see search parameters
      # @see Searchable#search
      def search(query, **params)
        restricted_params = { restrict_to: get_attribute(:display_name) }.merge(params)
        super(query, restricted_params)
      end

      # @!group Listings

      # Get the appropriate listing.
      # @param sort [:hot, :new, :top, :controversial, :comments, :rising, :gilded] the type of
      #   listing
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [:hour, :day, :week, :month, :year, :all] :time the time period to consider
      #   when sorting
      #
      # @note The option :time only applies to the top and controversial sorts.
      # @return [Listing<Submission, Comment>]
      def listing(sort, **params)
        params[:t] = params.delete(:time) if params.key?(:time)
        @client.model(:get, "/r/#{get_attribute(:display_name)}/#{sort}", params)
      end

      # @!method hot(**params)
      # @!method new(**params)
      # @!method top(**params)
      # @!method controversial(**params)
      # @!method comments(**params)
      # @!method rising(**params)
      # @!method gilded(**params)
      #
      # @see #listing
      %i[hot new top controversial comments rising gilded].each do |sort|
        define_method(sort) { |**params| listing(sort, **params) }
      end

      # @!endgroup
      # @!group Moderator Listings

      # Get the appropriate moderator listing.
      # @param type [:reports, :spam, :modqueue, :unmoderated, :edited] the type of listing
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [:links, :comments] :only the type of objects required
      #
      # @return [Listing<Submission, Comment>]
      def moderator_listing(type, **params)
        @client.model(:get, "/r/#{get_attribute(:display_name)}/about/#{type}", params)
      end

      # @!method reports(**params)
      # @!method spam(**params)
      # @!method modqueue(**params)
      # @!method unmoderated(**params)
      # @!method edited(**params)
      #
      # @see #moderator_listing
      %i[reports spam modqueue unmoderated edited].each do |type|
        define_method(type) { |**params| moderator_listing(type, **params) }
      end

      # @!endgroup
      # @!group Relationship Listings

      # Get the appropriate relationship listing.
      # @param type [:banned, :muted, :wikibanned, :contributors, :wikicontributors, :moderators]
      #   the type of listing
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [String] :user find a specific user
      #
      # @return [Array<Hash>]
      def relationship_listing(type, **params)
        # TODO: add methods to determine if a certain user was banned/muted/etc
        # TODO: return User types?
        user_list = @client.get("/r/#{get_attribute(:display_name)}/about/#{type}", params).body
        user_list[:data][:children]
      end

      # @!method banned(**params)
      # @!method muted(**params)
      # @!method wikibanned(**params)
      # @!method contributors(**params)
      # @!method wikicontributors(**params)
      # @!method moderators(**params)
      #
      # @see #relationship_listing
      %i[banned muted wikibanned contributors wikicontributors moderators].each do |type|
        define_method(type) { |**params| relationship_listing(type, **params) }
      end

      # @!endgroup

      # Stream newly submitted posts.
      def post_stream(**params, &block)
        params[:limit] ||= 100
        stream = Utilities::Stream.new do |before|
          listing(:new, params.merge(before: before))
        end
        block_given? ? stream.stream(&block) : stream.enum_for(:stream)
      end

      # Stream newly submitted comments.
      def comment_stream(**params, &block)
        params[:limit] ||= 100
        stream = Utilities::Stream.new do |before|
          listing(:comments, params.merge(before: before))
        end
        block_given? ? stream.stream(&block) : stream.enum_for(:stream)
      end

      # Submit a link or a text post to the subreddit.
      # @note If both text and url are provided, url takes precedence.
      #
      # @param title [String] the title of the submission
      # @param text [String] the text of the self-post
      # @param url [String] the URL of the link
      # @param resubmit [Boolean] whether to post a link to the subreddit despite it having been
      #   posted there before (you monster)
      # @param sendreplies [Boolean] whether to send the replies to your inbox
      # @return [Submission] The returned object (url, id and name)
      def submit(title, text: nil, url: nil, resubmit: false, sendreplies: true)
        params = {
          title: title, sr: get_attribute(:display_name),
          resubmit: resubmit, sendreplies: sendreplies
        }
        params[:kind] = url ? 'link' : 'self'
        params[:url]  = url  if url
        params[:text] = text if text
        Submission.new(@client, @client.post('/api/submit', params).body[:json][:data])
      end

      # Compose a message to the moderators of a subreddit.
      #
      # @param subject [String] the subject of the message
      # @param text [String] the message text
      # @param from [Subreddit, nil] the subreddit to send the message on behalf of
      def send_message(subject:, text:, from: nil)
        super(to: "/r/#{get_attribute(:display_name)}", subject: subject, text: text, from: from)
      end

      # Set the flair for a link or a user for this subreddit.
      # @param thing [User, Submission] the object whose flair to edit
      # @param text [String] a string no longer than 64 characters
      # @param css_class [String] the css class to assign to the flair
      def set_flair(thing, text, css_class: nil)
        key = thing.is_a?(User) ? :name : :link
        params = { :text => text, key => thing.name }
        params[:css_class] = css_class if css_class
        @client.post("/r/#{get_attribute(:display_name)}/api/flair", params)
      end

      # Get a listing of all user flairs.
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [String] :name prefer {#get_flair}
      # @option params [:links, :comments] :only the type of objects required
      #
      # @return [Listing<Hash<Symbol, String>>]
      def flair_listing(**params)
        res = @client.get("/r/#{get_attribute(:display_name)}/api/flairlist", params).body
        Listing.new(@client, children: res[:users], before: res[:prev], after: res[:next])
      end

      # Get the user's flair data.
      # @param user [User] the user whose flair to fetch
      # @return [Hash, nil]
      def get_flair(user)
        # We have to do this because reddit returns all flairs if given a nonexistent user
        flair = flair_listing(name: user.name).first
        return flair if flair && flair[:user].casecmp(user.name).zero?
        nil
      end

      # Remove the flair from a user
      # @param thing [User, String] a User from which to remove flair
      def delete_flair(user)
        name = user.is_a?(User) ? user.name : user
        @client.post("/r/#{get_attribute(:display_name)}/api/deleteflair", name: name)
      end

      # Set a Submission's or User's flair based on a flair template id.
      # @param thing [User, Submission] an object to assign a template to
      # @param template_id [String] the UUID of the flair template to assign
      # @param text [String] optional text for the flair
      def set_flair_template(thing, template_id, text: nil)
        key = thing.is_a?(User) ? :name : :link
        params = { key => thing.name, flair_template_id: template_id, text: text }
        @client.post("/r/#{get_attribute(:display_name)}/api/selectflair", params)
      end

      # Add the subreddit to the user's subscribed subreddits.
      def subscribe(action: :sub, skip_initial_defaults: false)
        @client.post(
          '/api/subscribe',
          sr_name: get_attribute(:display_name),
          action: action,
          skip_initial_defaults: skip_initial_defaults
        )
      end

      # Remove the subreddit from the user's subscribed subreddits.
      def unsubscribe
        subscribe(action: :unsub)
      end

      # Get the subreddit's CSS.
      # @return [String, nil] the stylesheet or nil if no stylesheet exists
      def stylesheet
        url = @client.get("/r/#{get_attribute(:display_name)}/stylesheet").headers['location']
        HTTP.get(url).body.to_s
      rescue Redd::NotFound
        nil
      end

      # Edit the subreddit's stylesheet.
      # @param text [String] the updated CSS
      # @param reason [String] the reason for modifying the stylesheet
      def update_stylesheet(text, reason: nil)
        params = { op: 'save', stylesheet_contents: text }
        params[:reason] = reason if reason
        @client.post("/r/#{get_attribute(:display_name)}/api/subreddit_stylesheet", params)
      end

      # @return [Hash] the subreddit's settings
      def settings
        @client.get("/r/#{get_attribute(:display_name)}/about/edit").body[:data]
      end

      # Modify the subreddit's settings.
      # @param params [Hash] the settings to change
      # @see https://www.reddit.com/dev/api#POST_api_site_admin
      def modify_settings(**params)
        full_params = settings.merge(params)
        full_params[:sr] = get_attribute(:name)
        SETTINGS_MAP.each { |src, dest| full_params[dest] = full_params.delete(src) }
        @client.post('/api/site_admin', full_params)
      end

      # Get the moderation log.
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [String] :type filter events to a specific type
      #
      # @return [Listing<ModAction>]
      def mod_log(**params)
        @client.model(:get, "/r/#{get_attribute(:display_name)}/about/log", params)
      end

      # Invite a user to moderate this subreddit.
      # @param user [User] the user to invite
      # @param permissions [String] the permission string to invite the user with
      def invite_moderator(user, permissions: '+all')
        add_relationship(type: 'moderator_invite', name: user.name, permissions: permissions)
      end

      # Take back a moderator request.
      # @param user [User] the requested user
      def uninvite_moderator(user)
        remove_relationship(type: 'moderator_invite', name: user.name)
      end

      # Accept an invite to become a moderator of this subreddit.
      def accept_moderator_invite
        @client.post("/r/#{get_attribute(:display_name)}/api/accept_moderator_invite")
      end

      # Dethrone a moderator.
      # @param user [User] the user to remove
      def remove_moderator(user)
        remove_relationship(type: 'moderator', name: user.name)
      end

      # Leave from being a moderator on a subreddit.
      def leave_moderator
        @client.post('/api/leavemoderator', id: get_attribute(:name))
      end

      # Add a contributor to the subreddit.
      # @param user [User] the user to add
      def add_contributor(user)
        add_relationship(type: 'contributor', name: user.name)
      end

      # Remove a contributor from the subreddit.
      # @param user [User] the user to remove
      def remove_contributor(user)
        remove_relationship(type: 'contributor', name: user.name)
      end

      # Leave from being a contributor on a subreddit.
      def leave_contributor
        @client.post('/api/leavecontributor', id: get_attribute(:name))
      end

      # Ban a user from a subreddit.
      # @param user [User] the user to ban
      # @param params [Hash] additional options to supply with the request
      # @option params [String] :ban_reason the reason for the ban
      # @option params [String] :ban_message a message sent to the banned user
      # @option params [String] :note a note that only moderators can see
      # @option params [Integer] :duration the number of days to ban the user (if temporary)
      def ban(user, **params)
        add_relationship(type: 'banned', name: user.name, **params)
      end

      # Remove a ban on a user.
      # @param user [User] the user to unban
      def unban(user)
        remove_relationship(type: 'banned', name: user.name)
      end

      # Allow a user to contribute to the wiki.
      # @param user [User] the user to add
      def add_wiki_contributor(user)
        add_relationship(type: 'wikicontributor', name: user.name)
      end

      # No longer allow a user to contribute to the wiki.
      # @param user [User] the user to remove
      def remove_wiki_contributor(user)
        remove_relationship(type: 'wikicontributor', name: user.name)
      end

      # Ban a user from contributing to the wiki.
      # @param user [User] the user to ban
      # @param params [Hash] additional options to supply with the request
      # @option params [String] :ban_reason the reason for the ban (not sure this matters)
      # @option params [String] :note a note that only moderators can see
      # @option params [Integer] :duration the number of days to ban the user (if temporary)
      def ban_wiki_contributor(user, **params)
        add_relationship(type: 'wikibanned', name: user.name, **params)
      end

      # No longer ban a user from contributing to the wiki.
      # @param user [User] the user to unban
      def unban_wiki_contributor(user)
        remove_relationship(type: 'wikibanned', name: user.name)
      end

      # Upload a subreddit-specific image.
      # @param file [String, IO] the image file to upload
      # @param image_type ['jpg', 'png'] the image type
      # @param upload_type ['img', 'header', 'icon', 'banner'] where to upload the image
      # @param image_name [String] the name of the image (if upload_type is 'img')
      # @return [String] the url of the uploaded file
      def upload_image(file:, image_type:, upload_type:, image_name: nil)
        file_data = HTTP::FormData::File.new(file)
        params = { img_type: image_type, upload_type: upload_type, file: file_data }
        params[:name] = image_name if upload_type.to_s == 'img'
        @client.post("/r/#{display_name}/api/upload_sr_img", params).body[:img_src]
      end

      private

      def default_loader
        return load_from_display_name if @attributes.key?(:display_name)
        return load_from_fullname if @attributes.key?(:name)
        get_attribute(:display_name) # Raises an error that display_name wasn't found.
      end

      # Return the attributes using the display_name (best option).
      def load_from_display_name
        @client.get("/r/#{get_attribute(:display_name)}/about").body[:data]
      end

      # Load the attributes using the subreddit fullname (not so best option).
      def load_from_fullname
        response = @client.get('/api/info', id: get_attribute(:name))
        raise Redd::NotFound.new(response) if response.body[:data][:children].empty?
        response.body[:data][:children][0][:data]
      end

      def add_relationship(**params)
        @client.post("/r/#{get_attribute(:display_name)}/api/friend", params)
      end

      def remove_relationship(**params)
        @client.post("/r/#{get_attribute(:display_name)}/api/unfriend", params)
      end
    end
  end
end
