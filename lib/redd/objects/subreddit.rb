require_relative "thing"

module Redd
  module Objects
    # A comment made on links.
    class Subreddit < Thing
      alias_property :header_image, :header_img
      alias_property :nsfw?, :over18
      alias_property :users_online, :accounts_active
      alias_property :type, :subreddit_type
      alias_property :times_gilded, :gilded
    end
  end
end
