# frozen_string_literal: true

require_relative 'model'
require_relative 'gildable'
require_relative 'inboxable'
require_relative 'moderatable'
require_relative 'postable'
require_relative 'replyable'
require_relative 'reportable'

require_relative 'listing'
require_relative 'subreddit'
require_relative 'user'

module Redd
  module Models
    # A comment.
    class Comment < Model
      include Gildable
      include Inboxable
      include Moderatable
      include Postable
      include Replyable
      include Reportable

      # @!attribute [r] subreddit_id
      #   @return [String] the subreddit fullname
      property :subreddit_id

      # @!attribute [r] approved_at
      #   @return [Time, nil] the time when the comment was approved
      property :approved_at, from: :approved_at_utc, with: ->(t) { Time.at(t) if t }

      # @!attribute [r] banned_by
      #   @return [String] the user (?) that banned this comment
      property :banned_by

      # @!attribute [r] removal_reason
      #   @return [String, nil] the reason for comment removal
      property :removal_reason

      # @!attribute [r] link
      #   @return [Submission] the link that the comment was posted to
      property :link, from: :link_id, with: ->(id) { Submission.new(client, name: id) }

      # @!attribute [r] upvoted?
      #   @return [Boolean, nil] whether the user liked/disliked this comment
      property :upvoted?, from: :likes

      # @!attribute [r] replies
      #   @return [Listing<Comment>] the comment replies
      property :replies,
               default: ->() { Listing.empty(client) },
               with: ->(r) { r.is_a?(Hash) ? Listing.new(client, r[:data]) : Listing.empty(client) }

      # @!attribute [r] user_reports
      #   @return [Array<String>] user reports
      property :user_reports

      # @!attribute [r] saved?
      #   @return [Boolean] whether the submission was saved by the logged-in user
      property :saved?, from: :saved

      # @!attribute [r] id
      #   @return [String] the comment id
      property :id

      # @!attribute [r] banned_at
      #   @return [Time, nil] the time when the comment was banned
      property :banned_at, from: :banned_at_utc, with: ->(t) { Time.at(t) if t }

      # @!attribute [r] gilded
      #   @return [Integer] the number of times the comment was gilded
      property :gilded

      # @!attribute [r] archived?
      #   @return [Boolean] whether this comment was archived
      property :archived?, from: :archived

      # @!attribute [r] report_reasons
      #   @return [Array<String>] report reasons
      property :report_reasons

      # @!attribute [r] author
      #   @return [User] the comment author
      property :author, with: ->(name) { User.new(client, name: name) }

      # @!attribute [r] can_mod_post?
      #   @return [Boolean] whether the logged-in user can mod post
      property :can_mod_post?, from: :can_mod_post

      # @!attribute [r] ups
      #   @return [Integer] the comment upvotes
      #   @deprecated use {#score} instead
      property :ups

      # @!attribute [r] downs
      #   @return [Integer] the comment downvotes
      #   @deprecated is always 0; use {#score} instead
      property :downs

      # @!attribute [r] parent
      #   @return [Comment, Submission] the comment parent
      property :parent,
               from: :parent_id,
               with: ->(id) { Session.new(client).from_fullnames(id).first }

      # @!attribute [r] score
      #   @return [Integer] the comment score
      property :score

      # @!attribute [r] approved_by
      #   @return [String] the user that approved the comment
      property :approved_by

      # @!attribute [r] body
      #   @return [String] the markdown comment body
      property :body

      # @!attribute [r] body_html
      #   @return [String] the html-rendered version of the body
      property :body_html

      # @!attribute [r] edited_at
      #   @return [Time, nil] the time when the comment was edited
      property :edited_at, from: :edited, with: ->(t) { Time.at(t) if t }

      # @!attribute [r] author_flair_css_class
      #   @return [String] the author flair css class
      property :author_flair_css_class

      # @!attribute [r] collapsed?
      #   @return [Boolean] whether the comment was collapsed
      property :collapsed?, from: :collapsed

      # @!attribute [r] submitter?
      #   @return [Boolean] whether the comment author is the link submitter
      property :submitter?, from: :is_submitter

      # @!attribute [r] collapsed_reason
      #   @return [String] the reason for collapse (?)
      property :collapsed_reason

      # @!attribute [r] stickied?
      #   @return [Boolean] whether the comment was stickied
      property :stickied?, from: :stickied

      # @!attribute [r] can_gild?
      #   @return [Boolean] whether the comment is gildable
      property :can_gild?, from: :can_gild

      # @!attribute [r] subreddit
      #   @return [Subreddit] the comment's subreddit
      property :subreddit, with: ->(n) { Subreddit.new(client, display_name: n) }

      # @!attribute [r] score_hidden
      #   @return [Boolean] whether the comment score is hidden
      property :score_hidden?, from: :score_hidden

      # @!attribute [r] subreddit_type
      #   @return [String] subreddit type
      property :subreddit_type

      # @!attribute [r] name
      #   @return [String] the comment fullname
      property :name

      # @!attribute [r] author_flair_text
      #   @return [String] the author flair text
      property :author_flair_text

      # @!attribute [r] created_at
      #   @return [String] the time when the model was created
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] subreddit_name_prefixed
      #   @return [String] the subreddit name, prefixed with "r/"
      property :subreddit_name_prefixed

      # @!attribute [r] controversiality
      #   @return [Integer] the comment controversiality
      property :controversiality

      # @!attribute [r] depth
      #   @return [Integer] the comment depth
      property :depth

      # @!attribute [r] mod_reports
      #   @return [Array<String>] the moderator reports
      property :mod_reports

      # @!attribute [r] report_count
      #   @return [Integer] the report count
      property :report_count, from: :num_reports

      # @!attribute [r] distinguished?
      #   @return [Boolean] whether the comment is distinguished
      property :distinguished?, from: :distinguished

      private

      def lazer_reload
        self[:link] ? load_with_comments : load_without_comments
      end

      def load_with_comments
        fully_loaded!
        id = self[:id] || read_attribute(:name).sub('t1_', '')
        link_id = read_attribute(:link).name.sub('t3_', '')
        client.get("/comments/#{link_id}/_/#{id}").body[1][:data][:children][0][:data]
      end

      def load_without_comments
        id = self[:id] || read_attribute(:name).sub('t1_', '')
        response = client.get('/api/info', id: "t1_#{id}").body[:data][:children][0][:data]
        response.delete(:replies) # Make sure replies are lazy-loaded later.
        response
      end
    end
  end
end
