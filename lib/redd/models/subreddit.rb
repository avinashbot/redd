# frozen_string_literal: true

require_relative 'model'
require_relative 'messageable'
require_relative 'searchable'

module Redd
  module Models
    # A subreddit.
    class Subreddit < Model
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

      # @!group Listings

      # Get the appropriate listing.
      # @param sort [:hot, :new, :top, :controversial, :comments, :rising, :gilded] the type of
      #   listing
      # @param options [Hash] a list of options to send with the request
      # @option options [String] :after return results after the given fullname
      # @option options [String] :before return results before the given fullname
      # @option options [Integer, nil] :limit maximum number of items to return (nil for no limit)
      # @option options [:hour, :day, :week, :month, :year, :all] :time the time period to consider
      #   when sorting
      #
      # @note The option :time only applies to the top and controversial sorts.
      # @return [Listing<Submission, Comment>]
      def listing(sort, **options)
        options[:t] = options.delete(:time) if options.key?(:time)
        PaginatedListing.new(client, **options) do |**req_options|
          client.model(
            :get, "/r/#{read_attribute(:display_name)}/#{sort}", options.merge(req_options)
          )
        end
      end

      # @!method hot(**options)
      # @!method new(**options)
      # @!method top(**options)
      # @!method controversial(**options)
      # @!method comments(**options)
      # @!method rising(**options)
      # @!method gilded(**options)
      #
      # @see #listing
      %i[hot new top controversial comments rising gilded].each do |sort|
        define_method(sort) { |**options| listing(sort, **options) }
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
        client.model(:get, "/r/#{read_attribute(:display_name)}/about/#{type}", params)
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
        user_list = client.get("/r/#{read_attribute(:display_name)}/about/#{type}", params).body
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

      # @return [Array<String>] the subreddit's wiki pages
      def wiki_pages
        client.get("/r/#{read_attribute(:display_name)}/wiki/pages").body[:data]
      end

      # Get a wiki page by its title.
      # @param title [String] the page's title
      # @return [WikiPage]
      def wiki_page(title)
        WikiPage.new(client, title: title, subreddit: self)
      end

      # Search a subreddit.
      # @param query [String] the search query
      # @param params [Hash] refer to {Searchable} to see search parameters
      # @see Searchable#search
      def search(query, **params)
        restricted_params = { restrict_to: read_attribute(:display_name) }.merge(params)
        super(query, restricted_params)
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
          title: title, sr: read_attribute(:display_name),
          resubmit: resubmit, sendreplies: sendreplies
        }
        params[:kind] = url ? 'link' : 'self'
        params[:url]  = url  if url
        params[:text] = text if text
        Submission.new(client, client.post('/api/submit', params).body[:json][:data])
      end

      # Compose a message to the moderators of a subreddit.
      #
      # @param subject [String] the subject of the message
      # @param text [String] the message text
      # @param from [Subreddit, nil] the subreddit to send the message on behalf of
      def send_message(subject:, text:, from: nil)
        super(to: "/r/#{read_attribute(:display_name)}", subject: subject, text: text, from: from)
      end

      # Set the flair for a link or a user for this subreddit.
      # @param thing [User, Submission] the object whose flair to edit
      # @param text [String] a string no longer than 64 characters
      # @param css_class [String] the css class to assign to the flair
      def set_flair(thing, text, css_class: nil)
        key = thing.is_a?(User) ? :name : :link
        params = { :text => text, key => thing.name }
        params[:css_class] = css_class if css_class
        client.post("/r/#{read_attribute(:display_name)}/api/flair", params)
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
        res = client.get("/r/#{read_attribute(:display_name)}/api/flairlist", params).body
        Listing.new(client, children: res[:users], before: res[:prev], after: res[:next])
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
        client.post("/r/#{read_attribute(:display_name)}/api/deleteflair", name: name)
      end

      # Set a Submission's or User's flair based on a flair template id.
      # @param thing [User, Submission] an object to assign a template to
      # @param template_id [String] the UUID of the flair template to assign
      # @param text [String] optional text for the flair
      def set_flair_template(thing, template_id, text: nil)
        key = thing.is_a?(User) ? :name : :link
        params = { key => thing.name, flair_template_id: template_id, text: text }
        client.post("/r/#{read_attribute(:display_name)}/api/selectflair", params)
      end

      # Add the subreddit to the user's subscribed subreddits.
      def subscribe(action: :sub, skip_initial_defaults: false)
        client.post(
          '/api/subscribe',
          sr_name: read_attribute(:display_name),
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
        url = client.get("/r/#{read_attribute(:display_name)}/stylesheet").headers['location']
        HTTP.get(url).body.to_s
      rescue Errors::NotFound
        nil
      end

      # Edit the subreddit's stylesheet.
      # @param text [String] the updated CSS
      # @param reason [String] the reason for modifying the stylesheet
      def update_stylesheet(text, reason: nil)
        params = { op: 'save', stylesheet_contents: text }
        params[:reason] = reason if reason
        client.post("/r/#{read_attribute(:display_name)}/api/subreddit_stylesheet", params)
      end

      # @return [Hash] the subreddit's settings
      def settings
        client.get("/r/#{read_attribute(:display_name)}/about/edit").body[:data]
      end

      # Modify the subreddit's settings.
      # @param params [Hash] the settings to change
      # @see https://www.reddit.com/dev/api#POST_api_site_admin
      def modify_settings(**params)
        full_params = settings.merge(params)
        full_params[:sr] = read_attribute(:name)
        SETTINGS_MAP.each { |src, dest| full_params[dest] = full_params.delete(src) }
        client.post('/api/site_admin', full_params)
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
        client.model(:get, "/r/#{read_attribute(:display_name)}/about/log", params)
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
        client.post("/r/#{read_attribute(:display_name)}/api/accept_moderator_invite")
      end

      # Dethrone a moderator.
      # @param user [User] the user to remove
      def remove_moderator(user)
        remove_relationship(type: 'moderator', name: user.name)
      end

      # Leave from being a moderator on a subreddit.
      def leave_moderator
        client.post('/api/leavemoderator', id: read_attribute(:name))
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
        client.post('/api/leavecontributor', id: read_attribute(:name))
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
        client.post("/r/#{read_attribute(:display_name)}/api/upload_sr_img", params).body[:img_src]
      end

      # Delete a subreddit-specific image.
      # @param upload_type ['img', 'header', 'icon', 'banner'] the image to delete
      # @param image_name [String] the image name (if upload_type is 'img')
      def delete_image(upload_type:, image_name: nil)
        unless %w[img header icon banner].include?(upload_type)
          raise ArgumentError, 'unknown upload_type'
        end
        params = {}
        params[:name] = image_name if upload_type.to_s == 'img'
        client.post("/r/#{read_attribute(:display_name)}/api/delete_sr_#{upload_type}", params)
      end

      # @!attribute [r] display_name
      #   @return [String] the subreddit's name
      property :display_name, :required

      # @!attribute [r] id
      #   @return [String] the subreddit's base36 id.
      property :id

      # @!attribute [r] name
      #   @return [String] the subreddit's t5_ fullname.
      property :name

      # @!attribute [r] title
      #   @return [String] the subreddit's page title text.
      property :title

      # @!attribute [r] user_is_contributor?
      #   @return [Boolean] whether the logged-in user is the subreddit's contributor
      property :user_is_contributor?, from: :user_is_contributor

      # @!attribute [r] banner_image
      #   @return [String] the url to the subreddit's banner image
      property :banner_image, from: :banner_img

      # @!attribute [r] banner_size
      #   @return [Array<Integer>] the banner dimensions
      property :banner_size

      # @!attribute [r] user_flair_text
      #   @return [String] the logged-in user's flair text
      property :user_flair_text

      # @!attribute [r] user_flair_css_class
      #   @return [String] the css class for the user's flair
      property :user_flair_css_class

      # @!attribute [r] user_is_banned
      #   @return [Boolean] whether the logged-in user is banned from this subreddit
      property :user_is_banned?, from: :user_is_banned

      # @!attribute [r] user_is_moderator?
      #   @return [Boolean] whether the logged-in user is a moderator of the subreddit
      property :user_is_moderator?, from: :user_is_moderator

      # @!attribute [r] user_is_muted?
      #   @return [Boolean] whether the logged-in user is muted from the subreddit
      property :user_is_muted?, from: :user_is_muted

      # @!attribute [r] user_is_subscriber
      #   @return [Boolean] whether the logged-in user is a subscriber to the subreddit
      property :user_is_subscriber?, from: :user_is_subscriber

      # @!attribute [r] wiki_enabled?
      #   @return [Boolean] whether the wiki is enabled for this subreddit
      property :wiki_enabled?, from: :wiki_enabled

      # @!attribute [r] show_media?
      #   @return [Boolean] whether media is shown
      property :show_media?, from: :show_media

      # @!attribute [r] description
      #   @return [String] the subreddit description
      property :description

      # @!attribute [r] description_html
      #   @return [String] the html-rendered version of the subreddit description
      property :description_html

      # @!attribute [r] submit_text
      #   @return [String] the submit text
      property :submit_text

      # @!attribute [r] submit_text_html
      #   @return [String] the submit text html
      property :submit_text_html

      # @!attribute [r] can_set_flair?
      #   @return [Boolean] whether the user can set the flair in the subreddit
      property :can_set_flair?, from: :user_can_flair_in_sr

      # @!attribute [r] header_img
      #   @return [String] the url to the header image
      property :header_image, from: :header_img

      # @!attribute [r] header_size
      #   @return [Array<Integer>] the dimensions of the header image
      property :header_size

      # @!attribute [r] collapse_deleted_comments?
      #   @return [Boolean] whether deleted comments are collapsed
      property :collapse_deleted_comments?, from: :collapse_deleted_comments

      # @!attribute [r] user_has_favorited?
      #   @return [Boolean] whether the user has favourited the subreddit
      property :user_has_favorited?, from: :user_has_favorited

      # @!attribute [r] public_description
      #   @return [String] the public description
      property :public_description

      # @!attribute [r] public_description_html
      #   @return [String] the html-rendered version of the public description
      property :public_description_html

      # @!attribute [r] over_18?
      #   @return [Boolean] whether the user is marked as over 18
      property :over_18?, from: :over18

      # @!attribute [r] spoilers_enabled?
      #   @return [Boolean] whether the subreddit has spoilers enabled
      property :spoilers_enabled?, from: :spoilers_enabled

      # @!attribute [r] icon_size
      #   @return [Array<Integer>] the subreddit icon size
      property :icon_size

      # @!attribute [r] audience_target
      #   @return [String] no clue what this means
      property :audience_target

      # @!attribute [r] suggested_comment_sort
      #   @return [String] the suggested comment sort
      property :suggested_comment_sort

      # @!attribute [r] active_user_count
      #   @return [Integer] the number of active users
      property :active_user_count

      # @!attribute [r] accounts_active
      #   @return [Integer] the number of active accounts
      property :accounts_active

      # @!attribute [r] subscribers
      #   @return [Integer] the subreddit's subscriber count
      property :subscribers

      # @!attribute [r] icon_image
      #   @return [String] the url to the icon image
      property :icon_image, from: :icon_img

      # @!attribute [r] header_title
      #   @return [String] the header's "title" attribute (i.e. mouseover text)
      property :header_title

      # @!attribute [r] display_name_prefixed
      #   @return [String] the display name, prefixed with a "r/".
      #   @deprecated not really deprecated, but prefer just using the display_name directly
      property :display_name_prefixed, default: ->() { "r/#{read_attribute(:display_name)}" }

      # @!attribute [r] submit_link_label
      #   @return [String] the label text on the submit link button
      property :submit_link_label

      # @!attribute [r] submit_text_label
      #   @return [String] the label text on the submit text button
      property :submit_text_label

      # @!attribute [r] public_traffic
      #   @return [Boolean] whether the traffic page is public
      property :public_traffic?, from: :public_traffic

      # @!attribute [r] key_color
      #   @return [String] a hex color code, not sure what this does
      property :key_color

      # @!attribute [r] user_flair_visible?
      #   @return [Boolean] whether the user's flair is shown to others
      property :user_flair_visible?, from: :user_sr_flair_enabled

      # @!attribute [r] user_flair_enabled?
      #   @return [Boolean] whether the subreddit allows setting user flairs
      property :user_flair_enabled?, from: :user_flair_enabled_in_sr

      # @!attribute [r] language
      #   @return [String] the subreddit's language code
      property :language, from: :lang

      # @!attribute [r] enrolled_in_new_modmail?
      #   @return [Boolean] whether the subreddit is enrolled in the new modmail
      property :enrolled_in_new_modmail?, from: :is_enrolled_in_new_modmail

      # @!attribute [r] whitelist_status
      #   @return [String] not sure what this does, something to do with ads?
      property :whitelist_status

      # @!attribute [r] url
      #   @return [String] the subreddit's **relative** url (e.g. /r/Redd/)
      property :url, default: ->() { "/r/#{read_attribute(:display_name)}/" }

      # @!attribute [r] quarantined?
      #   @return [Boolean] whether the subreddit is quarantined
      property :quarantined?, from: :quarantine

      # @!attribute [r] hide_ads?
      #   @return [Boolean] whether ads are hidden?
      property :hide_ads?, from: :hide_ads

      # @!attribute [r] created_at
      #   @return [Time] the time the subreddit was created
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] accounts_active_is_fuzzed
      #   @return [Boolean] whether active accounts is fuzzed
      property :accounts_active_is_fuzzed?, from: :accounts_active_is_fuzzed

      # @!attribute [r] advertiser_category
      #   @return [String] the advertiser category
      property :advertiser_category

      # @!attribute [r] subreddit_theme_enabled?
      #   @return [Boolean] whether the subreddit theme is enabled
      property :subreddit_theme_enabled?, from: :user_sr_theme_enabled

      # @!attribute [r] link_flair_enabled
      #   @return [Boolean] whether link flairs are enabled
      property :link_flair_enabled?, from: :link_flair_enabled

      # @!attribute [r] allow_images?
      #   @return [Boolean] whether images are allowed
      property :allow_images?, from: :allow_images

      # @!attribute [r] show_media_preview
      #   @return [Boolean] whether media previews are shown
      property :show_media_preview?, from: :show_media_preview

      # @!attribute [r] comment_score_hide_mins
      #   @return [Integer] the number of minutes the comment score is hidden
      property :comment_score_hide_mins

      # @!attribute [r] subreddit_type
      #   @return [String] whether it's a public, private, or gold-restricted subreddit
      property :subreddit_type

      # @!attribute [r] submission_type
      #   @return [String] the allowed submission type (?)
      property :submission_type

      private

      def lazer_reload
        fully_loaded!
        exists_locally?(:name) ? load_from_fullname : load_from_display_name
      end

      # Return the attributes using the display_name (best option).
      def load_from_display_name
        client.get("/r/#{read_attribute(:display_name)}/about").body[:data]
      end

      # Load the attributes using the subreddit fullname (not so best option).
      def load_from_fullname
        response = client.get('/api/info', id: read_attribute(:name))
        raise Errors::NotFound.new(response) if response.body[:data][:children].empty?
        response.body[:data][:children][0][:data]
      end

      def add_relationship(**params)
        client.post("/r/#{read_attribute(:display_name)}/api/friend", params)
      end

      def remove_relationship(**params)
        client.post("/r/#{read_attribute(:display_name)}/api/unfriend", params)
      end
    end
  end
end
