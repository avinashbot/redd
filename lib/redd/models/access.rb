# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # Models access_token and related keys.
    # @note This model also supports an additional key, called `:created_at` which is a UNIX time
    #   representing the time the access was created. The default value is the time the object was
    #   initialized.
    class Access < Model
      # Create a non-lazily initialized Access.
      # @param attributes [Hash] the access's attributes
      # @example
      #   access = Redd::Models::Access.new(access_token: ...)
      def initialize(attributes = {})
        super(nil, attributes)
        @creation_time = Time.now
      end

      # Whether the access has expired.
      # @param grace_period [Integer] the grace period where the model expires early
      # @return [Boolean] whether the access has expired
      def expired?(grace_period = 60)
        Time.now > read_attribute(:created_at) + read_attribute(:expires_in) - grace_period
      end

      # @return [Boolean] whether the access can be refreshed
      def permanent?
        read_attribute(:refresh_token).nil?
      end

      # @!attribute [r] access_token
      #   @return [String] the access token
      property :access_token

      # @!attribute [r] refresh_token
      #   @return [String] the (optional) refresh token
      property :refresh_token, :nil

      # @!attribute [r] expires_in
      #   @return [Integer] the number of seconds before the access expires
      property :expires_in

      # @!attribute [r] created_at
      #   @return [Time] the time the access was created
      property :created_at, default: -> { @creation_time }

      # @!attribute [r] scope
      #   @return [Array<String>] the scopes that the user is allowed to access
      property :scope, with: ->(scope) { scope.split(' ') }
    end
  end
end
