require "redd/thing"
require "redd/object/listing"
require "redd/object/comment"
require "redd/object/more_comments"
require "redd/object/private_message"
require "redd/object/submission"
require "redd/object/subreddit"
require "redd/object/user"

module Redd
  module Client
    class Unauthenticated
      module Utilities
        def comment_stream(*args, &block)
          submission_stream(:comments, *args, &block)
        end

        def submission_stream(listing, subreddit = "all", params = {}, &block)
          loop do
            # Get the latest comments from the subreddit. By the way, this line
            #   is the one where the sleeping/rate-limiting happens.
            objects = get_listing(listing, subreddit, params)
            unless objects.empty?
              # Set the latest comment.
              params[:before] = objects.first.fullname
              # Run the loop for each of the new comments accessed.
              # I should probably add it to some sort of Set to avoid duplicates.
              objects.reverse_each { |object| block.call(object) }
            end
          end
        end

        private

        def extract_attribute(object, attribute)
          case object
          when ::String
            object
          else
          	object.send(attribute)
          end
        end

        def extract_fullname(object)
          extract_attribute(object, :fullname)
        end

        def extract_id(object)
          extract_attribute(object, :id)
        end

        def object_from_kind(kind) # rubocop:disable Style/MethodLength
          case kind
          when "Listing"
            Redd::Object::Listing
          when "more"
            Redd::Object::MoreComments
          when "t1"
            Redd::Object::Comment
          when "t2"
            Redd::Object::User
          when "t3"
            Redd::Object::Submission
          when "t4"
            Redd::Object::PrivateMessage
          when "t5"
            Redd::Object::Subreddit
          else
            Redd::Thing
          end
        end

        def objects_from_listing(thing)
          thing[:data][:children].map do |child|
            object_from_body(child)
          end
        end

        def object_from_body(body)
          return nil unless body.is_a?(Hash) && body.has_key?(:kind)
          object = object_from_kind(body[:kind])

          if object == Redd::Object::Listing
            body[:data][:children] = objects_from_listing(body)
            object.new(body)
          else
            object.new(self, body)
          end
        end

        def comments_from_response(*args)
          body = request(*args)[1]
          object_from_body(body)
        end

        def object_from_response(*args)
          body = request(*args)
          object_from_body(body)
        end
      end
    end
  end
end
