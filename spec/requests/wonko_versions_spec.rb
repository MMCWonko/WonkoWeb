require 'rails_helper'

RSpec.describe "WonkoVersions", type: :request do
  describe "GET /wonko_versions" do
    it "works! (now write some real specs)" do
      get wonko_versions_path
      expect(response).to have_http_status(200)
    end
  end
end
