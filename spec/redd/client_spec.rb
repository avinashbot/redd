# frozen_string_literal: true

describe Redd::Client do
  describe '#get' do
    it 'makes a GET request' do
      request = stub_request(:get, 'https://test.com/get_request').with(query: { 'param' => '1' })
      Redd::Client.new(endpoint: 'https://test.com').get('/get_request', param: 1)
      expect(request).to have_been_made
    end
  end

  describe '#post' do
    it 'makes a POST request' do
      request = stub_request(:post, 'https://test.com/post_request').with(body: { 'param' => '1' })
      Redd::Client.new(endpoint: 'https://test.com').post('/post_request', param: 1)
      expect(request).to have_been_made
    end
  end

  describe '#put' do
    it 'makes a PUT request' do
      request = stub_request(:post, 'https://test.com/put_request').with(body: { 'param' => '1' })
      Redd::Client.new(endpoint: 'https://test.com').post('/put_request', param: 1)
      expect(request).to have_been_made
    end
  end

  describe '#patch' do
    it 'makes a PATCH request' do
      request = stub_request(:patch, 'https://test.com/ptch_request').with(body: { 'param' => '1' })
      Redd::Client.new(endpoint: 'https://test.com').patch('/ptch_request', param: 1)
      expect(request).to have_been_made
    end
  end

  describe '#delete' do
    it 'makes a DELETE request' do
      request = stub_request(:delete, 'https://test.com/del_request').with(body: { 'param' => '1' })
      Redd::Client.new(endpoint: 'https://test.com').delete('/del_request', param: 1)
      expect(request).to have_been_made
    end
  end
end
