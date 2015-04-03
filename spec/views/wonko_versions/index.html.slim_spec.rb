require 'rails_helper'

RSpec.describe 'wonko_versions/index', type: :view do
  let(:user) { nil }

  before(:each) do
    file = Fabricate(:wf_minecraft)
    assign(:wonko_file, file)
    assign(:wonko_versions, stub_pagination([
      Fabricate(:wv_minecraft_181, wonkofile: file),
      Fabricate(:wv_minecraft_183, wonkofile: file)
    ]))
  end

  pundit_view_helpers

  it 'renders a list of wonko_versions' do
    render
    assert_select 'tr'
  end
end
