require 'rails_helper'
require 'pry'
RSpec.describe 'wonko_versions/edit', type: :view do
  let(:wonko_version) { Fabricate(:wv_minecraft_183) }

  it 'renders the edit wonko_version form' do
    assign(:wonko_version, wonko_version)
    render

    assert_select 'form[action=?][method=?]',
                  wonko_file_wonko_version_path(wonko_version.wonkofile, wonko_version), 'post' do
      assert_select 'input#wonko_version_type[name=?]', 'wonko_version[type]'
      assert_select 'input#wonko_version_time[name=?]', 'wonko_version[time]'
    end
  end
end
