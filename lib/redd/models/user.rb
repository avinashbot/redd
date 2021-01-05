# frozen_string_literal: true

require_relative 'model'
require_relative 'messageable'

module Redd
  module Models
    # A reddit user.
    class User < Model
      include Messageable

      # Get the appropriate listing.
      # @param type [:overview, :submitted, :comments, :liked, :disliked, :hidden, :saved, :gilded]
      #   the type of listing to request
      # @param options [Hash] a list of options to send with the request
      # @option options [:hot, :new, :top, :controversial] :sort the order of the listing
      # @option options [String] :after return results after the given fullname
      # @option options [String] :before return results before the given fullname
      # @option options [Integer] :count the number of items already seen in the listing
      # @option options [1..100] :limit the maximum number of things to return
      # @option options [:hour, :day, :week, :month, :year, :all] :time the time period to consider
      #   when sorting
      # @option options [:given] :show whether to show the gildings given
      #
      # @note The option :time only applies to the top and controversial sorts.
      # @return [Listing<Submission>]
      def listing(type, **options)
        options[:t] = options.delete(:time) if options.key?(:time)
        PaginatedListing.new(client, **options) do |**req_opts|
          client.model(:get, "/user/#{read_attribute(:name)}/#{type}.json", options.merge(req_opts))
        end
      end

      # @!method overview(**params)
      # @!method submitted(**params)
      # @!method comments(**params)
      # @!method liked(**params)
      # @!method disliked(**params)
      # @!method hidden(**params)
      # @!method saved(**params)
      # @!method gilded(**params)
      #
      # @see #listing
      %i[overview submitted comments liked disliked hidden saved gilded].each do |type|
        define_method(type) { |**params| listing(type, **params) }
      end

      # Compose a message to the moderators of a subreddit.
      #
      # @param subject [String] the subject of the message
      # @param text [String] the message text
      # @param from [Subreddit, nil] the subreddit to send the message on behalf of
      def send_message(subject:, text:, from: nil)
        super(to: read_attribute(:name), subject: subject, text: text, from: from)
      end

      # Block this user.
      def block
        client.post('/api/block_user', account_id: read_attribute(:id))
      end

      # @return [Array<Trophy>] this user's trophies
      def trophies
        client.get("/api/v1/user/#{read_attribute(:name)}/trophies")
              .body[:data][:trophies]
              .map { |t| client.unmarshal(t) }
      end

      # Unblock a previously blocked user.
      # @param me [User] (optional) the person doing the unblocking
      def unblock(me: nil)
        my_id = 't2_' + (me.is_a?(User) ? user.id : client.get('/api/v1/me').body[:id])
        # Talk about an unintuitive endpoint
        client.post('/api/unfriend', container: my_id, name: read_attribute(:name), type: 'enemy')
      end

      # Add the user as a friend.
      # @param note [String] a note for the friend
      def friend(note = nil)
        name = read_attribute(:name)
        body = JSON.generate(note ? { name: name, note: note } : { name: name })
        client.request(:put, "/api/v1/me/friends/#{name}", body: body)
      end

      # Unfriend the user.
      def unfriend
        name = read_attribute(:name)
        client.request(:delete, "/api/v1/me/friends/#{name}", raw: true, form: { id: name })
      end

      # Gift a redditor reddit gold.
      # @param months [Integer] the number of months of gold to gift
      def gift_gold(months: 1)
        client.post("/api/v1/gold/give/#{read_attribute(:name)}", months: months)
      end

      # @!attribute [r] name
      #   @return [String] the user's username
      property :name

      # @!attribute [r] employee?
      #   @return [Boolean] whether the user is a reddit employee
      property :employee?, from: :is_employee

      # @!attribute [r] features
      #   @return [Hash] a hash of features
      property :features

      # @!attribute [r] friend?
      #   @return [Boolean] whether the user is your friend
      property :friend?, from: :is_friend

      # @!attribute [r] no_profanity?
      #   @return [Boolean] whether the user chooses to filter profanity
      property :no_profanity?, from: :pref_no_profanity

      # @!attribute [r] suspended?
      #   @return [Boolean] whether the user is suspended
      property :suspended?, from: :is_suspended

      # @!attribute [r] geopopular
      #   @return [String]
      property :geopopular, from: :pref_geopopular

      # @!attribute [r] subreddit
      #   @return [Subreddit] the user's personal "subreddit"
      property :subreddit, with: ->(name) { Subreddit.new(client, display_name: name) if name }

      # @!attribute [r] sponsor?
      #   @return [Boolean]
      property :sponsor?, from: :is_sponsor

      # @!attribute [r] gold_expiration
      #   @return [Time, nil] the time when the user's gold expires
      property :gold_expiration, with: ->(epoch) { Time.at(epoch) if epoch }

      # @!attribute [r] id
      #   @return [String] the user's base36 id
      property :id

      # @!attribute [r] profile_image
      #   @return [String] a link to the user's profile image
      property :profile_image, from: :profile_img

      # @!attribute [r] over_18?
      #   @return [Boolean] whether the user's profile is considered over 18.
      property :over_18?, from: :profile_over_18

      # @!attribute [r] suspension_expiration
      #   @return [Time, nil] the time when the user's suspension expires
      property :suspension_expiration, from: :suspension_expiration_utc,
                                       with: ->(epoch) { Time.at(epoch) if epoch }

      # @!attribute [r] verified?
      #   @return [Boolean] whether the user is verified (?)
      property :verified?, from: :verified

      # @!attribute [r] new_modmail_exists?
      #   @return [Boolean] whether the user has mail in the new modmail
      property :new_modmail_exists?, from: :new_modmail_exists

      # @!attribute [r] over_18?
      #   @return [Boolean] whether the user has indicated they're over 18
      property :over_18?, from: :over_18

      # @!attribute [r] gold?
      #   @return [Boolean] whether the user currently has gold
      property :gold?, from: :is_gold

      # @!attribute [r] mod?
      #   @return [Boolean] whether the user is a moderator
      property :mod?, from: :is_mod

      # @!attribute [r] has_verified_email?
      #   @return [Boolean] whether the user's email has been verified
      property :has_verified_email?, from: :has_verified_email

      # @!attribute [r] has_mod_mail?
      #   @return [Boolean] whether the user has old-style mod mail
      property :has_mod_mail?, from: :has_mod_mail

      # @!attribute [r] hidden_from_robots?
      #   @return [Boolean] whether the user chose to hide from Google
      property :hidden_from_robots?, from: :hide_from_robots

      # @!attribute [r] link_karma
      #   @return [Integer] the user's link karma
      property :link_karma

      # @!attribute [r] inbox_count
      #   @return [Integer] the number of messages in the user's inbox
      property :inbox_count

      # @!attribute [r] show_top_karma_subreddits?
      #   @return [Boolean] whether top karma subreddits are shown on the user's page
      property :show_top_karma_subreddits?, from: :pref_top_karma_subreddits

      # @!attribute [r] has_mail?
      #   @return [Boolean] whether the user has new messages
      property :has_mail?, from: :has_mail

      # @!attribute [r] show_snoovatar?
      #   @return [Boolean] whether the user's snoovatar is shown
      property :show_snoovatar?, from: :pref_show_snoovatar

      # @!attribute [r] created_at
      #   @return [Time] the time the user signed up
      property :created_at, from: :created_utc, with: ->(epoch) { Time.at(epoch) }

      # @!attribute [r] gold_creddits
      #   @return [Integer] the number of gold creddits the user has
      property :gold_creddits

      # @!attribute [r] in_beta?
      #   @return [Boolean] whether the user is in beta
      property :in_beta?, from: :in_beta

      # @!attribute [r] comment_karma
      #   @return [Integer] the user's comment karma
      property :comment_karma

      # @!attribute [r] has_subscribed?
      #   @return [Boolean]
      property :has_subscribed?, from: :has_subscribed

      private

      def lazer_reload
        # return load_from_fullname if self[:id] && !self[:name]
        fully_loaded!
        client.get("/user/#{read_attribute(:name)}/about").body[:data]
      end

      def load_from_fullname
        client.get('/api/user_data_by_account_ids', ids: read_attribute(:id)).body.values.first
      end
    end
  end
end
