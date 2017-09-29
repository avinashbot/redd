# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # Represents a moderator action, part of a moderation log.
    # @see Subreddit#log
    class ModAction < Model; end
  end
end
