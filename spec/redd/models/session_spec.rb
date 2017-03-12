# frozen_string_literal: true

RSpec.describe Redd::Models::Session do
  describe '#front_page' do
    it 'returns a FrontPage' do
      session = Redd::Models::Session.new(client)
      expect(session.front_page).to be_a(Redd::Models::FrontPage)
    end
  end

  describe '#me' do
    it 'returns a User' do
      session = Redd::Models::Session.new(client)
      expect(session.me).to be_a(Redd::Models::User)
    end
  end

  describe '#user' do
    it 'returns a User' do
      session = Redd::Models::Session.new(client)
      expect(session.user('Mustermind')).to be_a(Redd::Models::User)
    end
    it 'returns a User with the given name' do
      session = Redd::Models::Session.new(client)
      expect(session.user('Mustermind').name).to eq('Mustermind')
    end
  end

  describe '#subreddit' do
    it 'returns a Subreddit' do
      session = Redd::Models::Session.new(client)
      expect(session.subreddit('pics')).to be_a(Redd::Models::Subreddit)
    end
    it 'returns a Subreddit with the given name' do
      session = Redd::Models::Session.new(client)
      expect(session.subreddit('pics').display_name).to eq('pics')
    end
  end
end
