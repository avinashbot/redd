# frozen_string_literal: true

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

      # Make a Subreddit from its name.
      # @option hash [String] :display_name the subreddit's name
      # @return [Subreddit]
      def self.from_response(client, hash)
        name = hash.fetch(:display_name)
        new(client, hash) { |c| c.get("/r/#{name}/about").body[:data] }
      end

      # Create a Subreddit from its name.
      # @param client [APIClient] the api client to initialize the object with
      # @param id [String] the subreddit name
      # @return [Subreddit]
      def self.from_id(client, id)
        from_response(client, display_name: id)
      end

      # @return [Array<String>] the subreddit's wiki pages
      def wiki_pages
        @client.get("/r/#{get_attribute(:display_name)}/wiki/pages").body[:data]
      end

      # Get a wiki page by its title.
      # @param title [String] the page's title
      # @return [WikiPage]
      def wiki_page(title)
        WikiPage.from_response(@client, title: title, subreddit: self)
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
      # @param sort [:hot, :new, :top, :controversial, :comments, :rising] the type of listing
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
        @client.model(:get, "/r/#{get_attribute(:display_name)}/#{sort}.json", params)
      end

      # @!method hot(**params)
      # @!method new(**params)
      # @!method top(**params)
      # @!method controversial(**params)
      # @!method comments(**params)
      # @!method rising(**params)
      #
      # @see #listing
      %i(hot new top controversial comments rising).each do |sort|
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
        @client.model(:get, "/r/#{get_attribute(:display_name)}/about/#{type}.json", params)
      end

      # @!method reports(**params)
      # @!method spam(**params)
      # @!method modqueue(**params)
      # @!method unmoderated(**params)
      # @!method edited(**params)
      #
      # @see #moderator_listing
      %i(reports spam modqueue unmoderated edited).each do |type|
        define_method(type) { |**params| moderator_listing(type, **params) }
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
        Submission.from_response(@client, @client.post('/api/submit', params).body[:json][:data])
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
    end
  end
end
