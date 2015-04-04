require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  login_user

  describe 'GET #show' do
    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #files' do
    it 'returns http success' do
      get :files
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #versions' do
    it 'returns http success' do
      get :versions
      expect(response).to have_http_status(:success)
    end
  end
end
