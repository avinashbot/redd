# frozen_string_literal: true

require_relative 'model'
require_relative 'gildable'
require_relative 'moderatable'
require_relative 'postable'
require_relative 'replyable'
require_relative 'reportable'

require_relative 'user'
require_relative 'subreddit'

module Redd
  module Models
    # A text or link post.
    class Submission < Model
      include Gildable
      include Moderatable
      include Postable
      include Replyable
      include Reportable

      # @return [String] the sort order
      def sort_order
        exists_locally?(:sort_order) ? read_attribute(:sort_order) : nil
      end

      # Set the sort order of the comments and reload the comments.
      # @param new_order [:confidence, :top, :controversial, :old, :qa] the sort order
      def update_sort_order(new_order)
        return self if new_order == read_attribute(:sort_order)

        write_attribute(:sort_order, new_order)
        reload
      end

      # Get all submissions for the same url.
      # @param params [Hash] A list of optional params to send with the request.
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count (0) the number of items already seen in the listing
      # @option params [1..100] :limit (25) the maximum number of things to return
      # @return [Listing<Submission>]
      def duplicates(**params)
        client.unmarshal(client.get("/duplicates/#{read_attribute(:id)}", params).body[1])
      end

      # Mark the link as "Not Suitable For Work".
      def mark_as_nsfw
        client.get('/api/marknsfw', id: read_attribute(:name))
      end

      # No longer mark the link as "Not Suitable For Work".
      def unmark_as_nsfw
        client.get('/api/unmarknsfw', id: read_attribute(:name))
      end

      # Mark the link as a spoiler.
      def mark_as_spoiler
        client.get('/api/spoiler', id: read_attribute(:name))
      end

      # No longer mark the link as a spoiler.
      def unmark_as_spoiler
        client.get('/api/unspoiler', id: read_attribute(:name))
      end

      # Set the submission to "contest mode" (comments are randomly sorted)
      def enable_contest_mode
        client.post('/api/set_contest_mode', id: read_attribute(:name), state: true)
      end

      # Disable the "contest mode".
      def disable_contest_mode
        client.post('/api/set_contest_mode', id: read_attribute(:name), state: false)
      end

      # Set the submission as the sticky post of the subreddit.
      # @param slot [1, 2] which "slot" to place the sticky on
      def make_sticky(slot: nil)
        client.post('/api/set_subreddit_sticky', id: read_attribute(:name), num: slot, state: true)
      end

      # Unsticky the post from the subreddit.
      def remove_sticky
        client.post('/api/set_subreddit_sticky', id: read_attribute(:name), state: false)
      end

      # Prevent users from commenting on the link (and hide it as well).
      def lock
        client.post('/api/lock', id: read_attribute(:name))
      end

      # Allow users to comment on the link again.
      def unlock
        client.post('/api/unlock', id: read_attribute(:name))
      end

      # Set the suggested sort order for comments for all users.
      # @param suggested ['blank', 'confidence', 'top', 'new', 'controversial', 'old', 'random',
      #   'qa', 'live'] the sort type
      def set_suggested_sort(suggested) # rubocop:disable Naming/AccessorMethodName
        client.post('/api/set_suggested_sort', id: read_attribute(:name), sort: suggested)
      end

      # @!attribute [r] sort_order
      #   @return [Symbol] the comment sort order
      property :sort_order, :nil

      # @!attribute [r] comments
      #   @return [Array<Comment>] the comment tree
      property :comments, :nil, with: ->(l) { Listing.new(client, l) if l }

      # @!attribute [r] domain
      #   @return [String] the domain name of the link (or self.subreddit_name)
      property :domain

      # @!attribute [r] approved_at
      #   @return [Time, nil] when the submission was last approved
      property :approved_at, from: :approved_at_utc, with: ->(t) { Time.at(t) if t }

      # @!attribute [r] banned_by
      #   @return [String] not sure what this does
      property :banned_by

      # @!attribute [r] media_embed
      #   @return [Hash] media embed properties
      property :media_embed

      # @!attribute [r] subreddit
      #   @return [Subreddit] the subreddit the post belongs to.
      property :subreddit, with: ->(n) { Subreddit.new(client, display_name: n) }

      # @!attribute [r] selftext_html
      #   @return [String, nil] the html-rendered self text, can be nil if link
      property :selftext_html

      # @!attribute [r] selftext
      #   @return [String] the self text contents
      property :selftext

      # @!attribute [r] upvoted?
      #   @return [Boolean, nil] whether the user upvoted/downvoted this post
      property :upvoted?, from: :likes

      # @!attribute [r] suggested_sort
      #   @return [String, nil] the suggested sort
      property :suggested_sort

      # @!attribute [r] user_reports
      #   @return [Array<String>] user reports
      property :user_reports

      # @!attribute [r] secure_media
      #   @return [Hash, nil] secure media details
      property :secure_media

      # @!attribute [r] link_flair_text
      #   @return [String] the link flair text
      property :link_flair_text

      # @!attribute [r] link_flair_css_class
      #   @return [String] the link flair css class
      property :link_flair_css_class

      # @!attribute [r] id
      #   @return [String] the submission id
      property :id

      # @!attribute [r] banned_at
      #   @return [Time, nil] the time the post was banned
      property :banned_at, from: :banned_at_utc, with: ->(t) { Time.at(t) if t }

      # @!attribute [r] view_count
      #   @return [Integer, nil] the view count
      property :view_count

      # @!attribute [r] archived?
      #   @return [Boolean] whether the post is archived
      property :archived?, from: :archived

      # @!attribute [r] clicked?
      #   @return [Boolean] whether the post was clicked
      property :clicked?, from: :clicked

      # @!attribute [r] report_reasons
      #   @return [Object] i think it's an array of strings?
      property :report_reasons

      # @!attribute [r] title
      #   @return [String] the post title
      property :title

      # @!attribute [r] num_crossposts
      #   @return [Integer] the number of crossposts made to other subreddits
      property :num_crossposts

      # @!attribute [r] saved?
      #   @return [String] whether the post was saved by the logged-in user
      property :saved?, from: :saved

      # @!attribute [r] can_mod_post?
      #   @return [Boolean] whether you can post as a mod, i think
      property :can_mod_post?, from: :can_mod_post

      # @!attribute [r] crosspostable?
      #   @return [Boolean] whether the post can be crossposted
      property :crosspostable?, from: :is_crosspostable

      # @!attribute [r] pinned?
      #   @return [Boolean] whether the post is pinned
      property :pinned?, from: :pinned

      # @!attribute [r] score
      #   @return [Integer] the post's score
      property :score

      # @!attribute [r] approved_by
      #   @return [Object] the person that approved this post (not sure about the schema)
      property :approved_by

      # @!attribute [r] over_18?
      #   @return [Boolean] whether the post is marked as over 18
      property :over_18?, from: :over_18

      # @!attribute [r] hidden?
      #   @return [Boolean] whether the logged-in user hid the post
      property :hidden?, from: :hidden

      # @!attribute [r] preview
      #   @return [Hash] preview details
      property :preview

      # @!attribute [r] comment_count
      #   @return [Integer] the post's comment count
      property :comment_count, from: :num_comments

      # @!attribute [r] thumbnail
      #   @return [String] the thumbnail url
      property :thumbnail

      # @!attribute [r] thumbnail_height
      #   @return [Integer] thumbnail height
      property :thumbnail_height

      # @!attribute [r] score_hidden?
      #   @return [Boolean] whether the score is hidden
      property :score_hidden?, from: :hide_score

      # @!attribute [r] edited
      #   @return [Time, false] the time of the last edit
      property :edited, with: ->(t) { Time.at(t) if t }

      # @!attribute [r] author_flair_text
      #   @return [String] the author flair text
      property :author_flair_text

      # @!attribute [r] author_flair_css_class
      #   @return [String] the author flair css class
      property :author_flair_css_class

      # @!attribute [r] contest_mode_enabled?
      #   @return [Boolean] whether contest mode is turned on
      property :contest_mode_enabled?, from: :contest_mode

      # @!attribute [r] gilded
      #   @return [Integer] the number of times the post was gilded
      property :gilded

      # @!attribute [r] locked?
      #   @return [Boolean] whether the post is locked
      property :locked?, from: :locked

      # @!attribute [r] ups
      #   @return [Integer] upvote count
      #   @deprecated this doesn't return the raw upvote count - use {#score} instead
      property :ups

      # @!attribute [r] downs
      #   @return [Integer] downvote count
      #   @deprecated this always returns zero - use {#score} instead
      property :downs

      # @!attribute [r] brand_safe?
      #   @return [Boolean] whether the post is marked as brand safe
      property :brand_safe?, from: :brand_safe

      # @!attribute [r] secure_media_embed
      #   @return [Hash] secure media embed details
      property :secure_media_embed

      # @!attribute [r] removal_reason
      #   @return [String] the removal reason
      property :removal_reason

      # @!attribute [r] post_hint
      #   @return [String] a hint at what the link should contain
      property :post_hint

      # @!attribute [r] can_gild?
      #   @return [Boolean] whether the user can gild this post
      property :can_gild?, from: :can_gild

      # @!attribute [r] parent_whitelist_status
      #   @return [String] ad-related whitelist stuff
      property :parent_whitelist_status

      # @!attribute [r] name
      #   @return [String] the fullname (i.e. t3_xxxxxx)
      property :name

      # @!attribute [r] spoiler?
      #   @return [Boolean] whether the post was marked as a spoiler
      property :spoiler?, from: :spoiler

      # @!attribute [r] permalink
      #   @return [String] the **relative** url permalink
      property :permalink

      # @!attribute [r] report_count
      #   @return [Integer] the number of reports
      property :report_count, from: :num_reports

      # @!attribute [r] whitelist_status
      #   @return [String] ad-related whitelist stuff
      property :whitelist_status

      # @!attribute [r] stickied?
      #   @return [Boolean] whether the post was stickied
      property :stickied?, from: :stickied

      # @!attribute [r] url
      #   @return [String] the link url
      property :url

      # @!attribute [r] quarantined?
      #   @return [Boolean] whether the post has been quarantined
      property :quarantined?, from: :quarantine

      # @!attribute [r] author
      #   @return [User] the post author
      property :author, with: ->(n) { User.new(client, name: n) }

      # @!attribute [r] created_at
      #   @return [Time] creation time
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] subreddit_name_prefixed
      #   @return [String] r/[subreddit name]
      property :subreddit_name_prefixed,
               default: -> { "r/#{read_attribute(:subreddit).display_name}" }

      # @!attribute [r] distinguished?
      #   @return [Boolean] whether the post is distinguished
      property :distinguished?, from: :distinguished

      # @!attribute [r] media
      #   @return [Hash] media details
      property :media

      # @!attribute [r] upvote_ratio
      #   @return [Float] the upvote ratio (ups/downs)
      property :upvote_ratio

      # @!attribute [r] mod_reports
      #   @return [Array] moderator reports
      property :mod_reports

      # @!attribute [r] self?
      #   @return [Boolean] whether the post is a self post
      property :self?, from: :is_self

      # @!attribute [r] visited?
      #   @return [Boolean] whether the post was visited
      property :visited?, from: :visited

      # @!attribute [r] subreddit_type
      #   @return [String] the subreddit's type
      property :subreddit_type

      # @!attribute [r] video?
      #   @return [Boolean] whether the post is probably a video
      property :video, from: :is_video

      private

      def lazer_reload
        fully_loaded!

        # Ensure we have the link's id.
        id = exists_locally?(:id) ? read_attribute(:id) : read_attribute(:name).sub('t3_', '')

        # If a specific sort order was requested, provide it.
        params = {}
        params[:sort] = read_attribute(:sort_order) if exists_locally?(:sort_order)

        # `response` is a pair (2-element array):
        #   - response[0] is a one-item listing containing the submission
        #   - response[1] is listing of comments
        response = client.get("/comments/#{id}", params).body
        response[0][:data][:children][0][:data].merge(comments: response[1][:data])
      end
    end
  end
end
