require 'rails_helper'

RSpec.describe 'wonko_files/show', type: :view do
  let(:wonko_file) { Fabricate(:wf_minecraft) }
  let(:user) { Fabricate(:user) }

  before(:each) do
    assign(:wonko_file, wonko_file)
  end

  pundit_view_helpers

  it 'renders attributes in <p>' do
    render
  end
end
