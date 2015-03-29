require 'rails_helper'

RSpec.describe 'wonko_files/edit', type: :view do
  let(:wonko_file) { Fabricate(:wf_minecraft) }

  before(:each) do
    assign(:wonko_file, wonko_file)
  end

  it 'renders the edit wonko_file form' do
    render

    assert_select 'form[action=?][method=?]', wonko_file_path(wonko_file), 'post' do
      assert_select 'input#wonko_file_name[name=?]', 'wonko_file[name]'
    end
  end
end
