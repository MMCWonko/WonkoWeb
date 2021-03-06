require 'rails_helper'

RSpec.describe WonkoFilesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/wonko_files').to route_to('wonko_files#index')
    end

    it 'routes to #new' do
      expect(get: '/wonko_files/new').to route_to('wonko_files#new')
    end

    it 'routes to #show' do
      expect(get: '/wonko_files/1').to route_to('wonko_files#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/wonko_files/1/edit').to route_to('wonko_files#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/wonko_files').to route_to('wonko_files#create')
    end

    it 'routes to #update' do
      expect(put: '/wonko_files/1').to route_to('wonko_files#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/wonko_files/1').to route_to('wonko_files#destroy', id: '1')
    end
  end
end
