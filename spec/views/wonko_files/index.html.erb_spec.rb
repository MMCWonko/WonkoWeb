require 'rails_helper'

RSpec.describe 'wonko_files/index', type: :view do
  before(:each) do
    assign(:wonko_files, [
      WonkoFile.create!(
        uid: '',
        name: ''
      ),
      WonkoFile.create!(
        uid: '',
        name: ''
      )
    ])
  end

  it 'renders a list of wonko_files' do
    render
    assert_select 'tr>td', text: ''.to_s, count: 2
    assert_select 'tr>td', text: ''.to_s, count: 2
  end
end
