# frozen_string_literal: true

RSpec.describe Redd::Models::Subreddit do
  describe '#wiki_pages' do
    it 'returns an array of strings' do
      stub_api(:get, '/r/test/wiki/pages') { response(kind: 'wikipagelisting', data: %w(one two)) }
      subreddit = Redd::Models::Subreddit.from_id(client, 'test')
      expect(subreddit.wiki_pages).to match_array(%w(one two))
    end
  end

  describe '#wiki_page' do
    it 'returns a WikiPage' do
      subreddit = Redd::Models::Subreddit.from_id(client, 'test')
      expect(subreddit.wiki_page('test')).to be_a(Redd::Models::WikiPage)
    end
  end

  describe '#submit' do
    it 'makes a request to reddit' do
      params = {
        title: 'title', sr: 'test', resubmit: false, sendreplies: true, kind: 'self', text: 'hello'
      }
      stub_api(:post, '/api/submit', params) { response(json: { data: { id: 't3_abc123' } }) }
      subreddit = Redd::Models::Subreddit.from_id(client, 'test')
      subreddit.submit('title', text: 'hello')
    end

    it 'returns a Submission' do
      params = {
        title: 'title', sr: 'test', resubmit: false, sendreplies: true, kind: 'self', text: 'hello'
      }
      stub_api(:post, '/api/submit', params) { response(json: { data: { id: 't3_abc123' } }) }
      subreddit = Redd::Models::Subreddit.from_id(client, 'test')
      expect(subreddit.submit('title', text: 'hello')).to be_a(Redd::Models::Submission)
    end
  end
end
