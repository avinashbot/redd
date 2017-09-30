# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # Represents a moderator action, part of a moderation log.
    # @see Subreddit#mod_log
    class ModAction < Model
      # @!attribute [r] description
      #   @return [String] the action description
      property :description

      # @!attribute [r] target_title
      #   @return [String] the title of the item that was targeted
      property :target_title

      # @!attribute [r] target_body
      #   @return [String] the body of the item that was targeted
      property :target_body

      # @!attribute [r] target_permalink
      #   @return [String] the **relative** permalink to the item
      property :target_permalink

      # @!attribute [r] target_author
      #   @return [User] the target user
      property :target_author, with: ->(n) { User.new(client, name: n) }

      # @!attribute [r] mod_id36
      #   @return [String] the id of the moderator that performed this action
      property :mod_id36

      # @!attribute [r] created_at
      #   @return [Time] the time when the action was done
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] subreddit
      #   @return [Subreddit] the subreddit the action was performed on
      property :subreddit, with: ->(n) { Subreddit.new(client, display_name: n) }

      # @!attribute [r] subreddit_name_prefixed
      #   @return [String] the subreddit name, prefixed with a "r/"
      property :subreddit_name_prefixed

      # @!attribute [r] subreddit_id36
      #   @return [String] the subreddit's id
      property :subreddit_id36, from: :sr_id36

      # @!attribute [r] details
      #   @return [String] the action details
      property :details

      # @!attribute [r] action
      #   @return [String] the action type
      property :action
    end
  end
end
