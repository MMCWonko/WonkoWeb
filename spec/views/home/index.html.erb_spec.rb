require 'rails_helper'

RSpec.describe 'home/index.html.erb', type: :view do
  let(:user) { nil }

  pundit_view_helpers

  it 'works' do
    assign(:wonko_files, stub_pagination([
      Fabricate(:wf_minecraft),
      Fabricate(:wf_lwjgl)
    ]))

    render
  end
end
