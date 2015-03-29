require 'rails_helper'

RSpec.describe 'WonkoVersions', type: :request do
  describe 'GET /wonko_file/<uid>/wonko_versions' do
    it 'works! (now write some real specs)' do
      get wonko_file_wonko_versions_path(Fabricate(:wf_minecraft))
      expect(response).to have_http_status(200)
    end
  end
end
