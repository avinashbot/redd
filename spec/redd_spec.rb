# frozen_string_literal: true

RSpec.describe Redd do
  describe '.it' do
    it 'returns a Session' do
      expect_any_instance_of(Redd::AuthStrategies::Script).to receive(:authenticate)
      session = Redd.it(client_id: '', secret: '', username: '', password: '')
      expect(session).to be_a(Redd::Models::Session)
    end

    context 'when only client_id, secret, username and password are provided' do
      it 'creates an API client with AuthStrategies::Script' do
        expect_any_instance_of(Redd::AuthStrategies::Script).to receive(:authenticate)
        Redd.it(client_id: '', secret: '', username: '', password: '')
      end
    end

    context 'when only client_id, redirect_uri and code are provided' do
      it 'creates an API client with AuthStrategies::Web' do
        expect_any_instance_of(Redd::AuthStrategies::Web).to receive(:authenticate).with('CD')
        Redd.it(client_id: '', redirect_uri: '', code: 'CD')
      end
    end

    context 'when only client_id, secret, redirect_uri and code are provided' do
      it 'creates an API client with AuthStrategies::Web' do
        expect_any_instance_of(Redd::AuthStrategies::Web).to receive(:authenticate).with('CD')
        Redd.it(client_id: '', secret: '', redirect_uri: '', code: 'CD')
      end
    end

    context 'when only client_id and secret are provided' do
      it 'creates an API client with AuthStrategies::Userless' do
        expect_any_instance_of(Redd::AuthStrategies::Userless).to receive(:authenticate)
        Redd.it(client_id: '', secret: '')
      end
    end
  end
end
