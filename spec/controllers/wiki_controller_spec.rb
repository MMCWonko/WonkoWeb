require 'rails_helper'

RSpec.describe WikiController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(302)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, page: 'Home'
      expect(response).to have_http_status(:success)
    end
  end
end
