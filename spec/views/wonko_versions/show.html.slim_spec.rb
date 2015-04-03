require 'rails_helper'

RSpec.describe 'wonko_versions/show', type: :view do
  let(:wonko_version) { Fabricate(:wv_minecraft_181) }
  let(:user) { Fabricate(:user) }

  before(:each) do
    assign :wonko_version, wonko_version
    assign :wonko_file, wonko_version.wonkofile
  end

  pundit_view_helpers

  it 'renders attributes in <p>' do
    render
  end
end
