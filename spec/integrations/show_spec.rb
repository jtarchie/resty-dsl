require 'spec_helper'

describe 'When getting a single resources' do
  def create_user
    User.create
  end

  let(:app) do
    resty do
      database ENV['DATABASE_URL']
      port ENV['PORT']
      resource :users do
        show { User }
      end
    end
  end

  context 'and that resource exists' do
    let!(:user) { create_user }

    before do
      get "/users/#{user.id}"
    end

    it 'has successful status' do
      expect( status ).to eq 200
    end

    it 'returns the JSON content-type' do
      expect( content_type ).to eq 'application/json'
    end

    it 'has valid JSON' do
      json = JSON.parse(body)
      expect(json).to eq [{"id"=>user.id}]
    end
  end

  context 'and that resource does not exist' do
    before do
      get '/users/1000'
    end

    it 'has status of not found' do
      expect( status ).to eq 404
    end

    it 'returns the JSON content-type' do
      expect( content_type ).to eq 'application/json'
    end

    it 'has valid JSON' do
      json = JSON.parse(body)
      expect(json).to eq ({'status'=>404})
    end
  end
end

