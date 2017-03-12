# frozen_string_literal: true

RSpec.describe Redd::APIClient do
  describe '#authenticate' do
    it 'calls #authenticate on the auth strategy with a given code' do
      auth_strategy = instance_double('Redd::AuthStrategies::AuthStrategy')
      expect(auth_strategy).to receive(:authenticate).with('some-code')
      Redd::APIClient.new(auth_strategy).authenticate('some-code')
    end

    it "sets the client's access to the result of the call" do
      auth_strategy = instance_double('Redd::AuthStrategies::AuthStrategy')
      access = double('Redd::Models::Access')
      allow(auth_strategy).to receive(:authenticate).and_return(access)

      client = Redd::APIClient.new(auth_strategy)
      client.authenticate
      expect(client.access).to eq(access)
    end
  end

  describe '#refresh' do
    it 'calls #refresh on the auth strategy' do
      auth_strategy = instance_double('Redd::AuthStrategies::AuthStrategy')
      api_client = Redd::APIClient.new(auth_strategy)
      api_client.access = double('Redd::Models::Access')

      expect(auth_strategy).to receive(:refresh).with(api_client.access)
      api_client.refresh
    end

    it "sets the client's access to the result of the call" do
      auth_strategy = instance_double('Redd::AuthStrategies::AuthStrategy')
      access = double('Redd::Models::Access')
      allow(auth_strategy).to receive(:refresh).and_return(access)

      client = Redd::APIClient.new(auth_strategy)
      client.refresh
      expect(client.access).to eq(access)
    end
  end

  describe '#revoke' do
    it 'calls #revoke on the auth strategy' do
      auth_strategy = instance_double('Redd::AuthStrategies::AuthStrategy')
      expect(auth_strategy).to receive(:revoke)
      Redd::APIClient.new(auth_strategy).revoke
    end

    it "unsets the client's access" do
      auth_strategy = instance_double('Redd::AuthStrategies::AuthStrategy')
      allow(auth_strategy).to receive(:revoke)

      client = Redd::APIClient.new(auth_strategy)
      client.revoke
      expect(client.access).to be_nil
    end
  end

  # TODO: expand into context blocks and implement
  it 'calls authenticate if auto_login is enabled and access is unset'
  it 'calls refresh if auto_refresh is enabled and access is expired'
  it 'retries a call if max_retries > 0 is enabled and a TimeoutError or a ServerError is raised'
end
