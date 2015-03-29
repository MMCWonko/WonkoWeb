require 'rails_helper'

RSpec.describe 'wonko_versions/new', type: :view do
  let(:wonko_version) { Fabricate(:wf_minecraft).wonkoversions.build(version: '1.2.2') }

  before(:each) do
    assign(:wonko_version, wonko_version)
  end

  it 'renders new wonko_version form' do
    render

    assert_select 'form[action=?][method=?]', wonko_file_wonko_versions_path(wonko_version.wonkofile), 'post' do
      assert_select 'input#wonko_version_version[name=?]', 'wonko_version[version]'
      assert_select 'input#wonko_version_type[name=?]', 'wonko_version[type]'
      assert_select 'input#wonko_version_time[name=?]', 'wonko_version[time]'
    end
  end
end
