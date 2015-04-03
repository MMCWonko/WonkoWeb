require 'rails_helper'

RSpec.describe 'wonko_files/new', type: :view do
  before(:each) do
    assign(:wonko_file, WonkoFile.new(
                          uid: '',
                          name: ''
    ))
  end

  it 'renders new wonko_file form' do
    render

    assert_select 'form[action=?][method=?]', wonko_files_path, 'post' do
      assert_select 'input#wonko_file_uid[name=?]', 'wonko_file[uid]'

      assert_select 'input#wonko_file_name[name=?]', 'wonko_file[name]'
    end
  end
end
