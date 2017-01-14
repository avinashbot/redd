# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # Models access_token and related keys.
    class Access < BasicModel
      def expired?(grace_period = 60)
        Time.now > @created_at + (get_attribute(:expires_in) - grace_period)
      end

      private

      def after_initialize
        @created_at = Time.now
      end
    end
  end
end
