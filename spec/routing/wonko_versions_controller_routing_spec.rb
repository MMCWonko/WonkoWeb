require 'rails_helper'

RSpec.describe WonkoVersionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/wonko_files/net.minecraft/wonko_versions').to route_to('wonko_versions#index',
                                                                           wonko_file_id: 'net.minecraft')
    end

    it 'routes to #new' do
      expect(get: '/wonko_files/net.minecraft/wonko_versions/new').to route_to('wonko_versions#new',
                                                                               wonko_file_id: 'net.minecraft')
    end

    it 'routes to #show' do
      expect(get: '/wonko_files/net.minecraft/wonko_versions/1').to route_to('wonko_versions#show',
                                                                             id: '1', wonko_file_id: 'net.minecraft')
    end

    it 'routes to #edit' do
      expect(get: '/wonko_files/net.minecraft/wonko_versions/1/edit').to route_to('wonko_versions#edit',
                                                                                  id: '1',
                                                                                  wonko_file_id: 'net.minecraft')
    end

    it 'routes to #create' do
      expect(post: '/wonko_files/net.minecraft/wonko_versions').to route_to('wonko_versions#create',
                                                                            wonko_file_id: 'net.minecraft')
    end

    it 'routes to #update' do
      expect(put: '/wonko_files/net.minecraft/wonko_versions/1').to route_to('wonko_versions#update',
                                                                             id: '1', wonko_file_id: 'net.minecraft')
    end

    it 'routes to #destroy' do
      expect(delete: '/wonko_files/net.minecraft/wonko_versions/1').to route_to('wonko_versions#destroy',
                                                                                id: '1', wonko_file_id: 'net.minecraft')
    end
  end
end
