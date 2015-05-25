require 'rails_helper'

RSpec.describe UploadersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/uploaders').to route_to('uploaders#index')
    end

    it 'routes to #new' do
      expect(get: '/users/uploaders/new').to route_to('uploaders#new')
    end

    it 'routes to #show' do
      expect(get: '/users/uploaders/1').to route_to('uploaders#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/uploaders/1/edit').to route_to('uploaders#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/uploaders').to route_to('uploaders#create')
    end

    it 'routes to #update' do
      expect(put: '/users/uploaders/1').to route_to('uploaders#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/uploaders/1').to route_to('uploaders#destroy', id: '1')
    end

    it 'routes to #reset_token' do
      expect(get: '/users/uploaders/1/reset_token').to route_to('uploaders#reset_token', id: '1')
    end
  end
end
