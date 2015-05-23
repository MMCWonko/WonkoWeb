require 'rails_helper'

RSpec.describe FeedController, type: :controller do
  describe 'GET #user' do
    login_user
    it 'returns http success' do
      get :user
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #file' do
    it 'returns http success' do
      get :file, id: Fabricate(:wf_minecraft).to_param
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #version' do
    it 'returns http success' do
      file = Fabricate(:wf_minecraft)
      version = Fabricate(:wv_minecraft_181, wonko_file: file)
      get :version, wonko_file_id: file.to_param, id: version.to_param
      expect(response).to have_http_status(:success)
    end
  end
end
