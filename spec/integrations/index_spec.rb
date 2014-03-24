require 'spec_helper'
require 'json'

describe 'When getting many resources' do
  def create_user
    User.create
  end

  context 'and a resource that exists' do
    let!(:user) { create_user }
    let(:app) do
      resty do
        database ENV['DATABASE_URL']
        port ENV['PORT']
        resource :users do
          index { User.all }
        end
      end
    end

    before do
      get '/users'
    end

    it 'has status of 200' do
      expect( status ).to eq 200
    end

    it 'returns the JSON content-type' do
      expect( content_type ).to eq 'application/json'
    end

    it 'has valid JSON' do
      json = JSON.parse(body)
      expect(json).to eq [{"id" => user.id}]
    end
  end
end
