require 'rails_helper'

RSpec.describe 'wonko_files/index', type: :view do
  let(:user) { nil }

  before(:each) do
    assign(:wonko_files, stub_pagination([
      Fabricate(:wf_minecraft),
      Fabricate(:wf_lwjgl)
    ]))
  end

  pundit_view_helpers

  it 'renders a list of wonko_files' do
    render
    assert_select 'tr'
  end
end
