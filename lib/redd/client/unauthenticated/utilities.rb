require "redd/thing"
require "redd/object/listing"
require "redd/object/comment"
require "redd/object/private_message"
require "redd/object/submission"
require "redd/object/subreddit"
require "redd/object/user"

module Redd
  module Client
    class Unauthenticated
      module Utilities
        private

        def extract_fullname(object)
          object.is_a?(String) ? object : extract_attribute(object, :fullname)
        end

        def extract_attribute(object, attribute)
          object.send(attribute) if object.respond_to?(attribute)
        end

        # @todo "more"
        def object_from_kind(kind) # rubocop:disable Style/MethodLength
          case kind
          when "Listing"
            Redd::Object::Listing
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
            get_object_from_body(child)
          end
        end

        def get_object_from_body(body)
          object = object_from_kind(body[:kind])

          if object == Redd::Object::Listing
            body[:data][:children] = objects_from_listing(body)
            object.new(body)
          else
            object.new(self, body)
          end
        end

        def object_from_response(*args)
          body = request(*args).body
          get_object_from_body(body)
        end
      end
    end
  end
end
