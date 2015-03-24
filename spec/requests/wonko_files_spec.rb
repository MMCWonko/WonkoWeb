require 'rails_helper'

RSpec.describe 'WonkoFiles', type: :request do
  describe 'GET /wonko_files' do
    it 'works! (now write some real specs)' do
      get wonko_files_path
      expect(response).to have_http_status(200)
    end
  end
end
