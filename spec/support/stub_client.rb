# frozen_string_literal: true

require 'redd/utilities/unmarshaller'

class StubClient
  # Holds a returned HTTP response.
  Response = Struct.new(:code, :headers, :body) do
    def raw_body
      @raw_body ||= JSON.generate(body)
    end
  end

  def initialize
    @unmarshaller = Redd::Utilities::Unmarshaller.new(self)
  end

  def unmarshal(object)
    @unmarshaller.unmarshal(object)
  end

  def model(verb, path, params = {})
    unmarshal(send(verb, path, params).body)
  end

  %i(get post put patch delete).each do |verb|
    define_method(verb) { |_path, _params = {}| raise 'stub this method' }
  end
end
