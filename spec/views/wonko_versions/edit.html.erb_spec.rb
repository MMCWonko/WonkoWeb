require 'rails_helper'

RSpec.describe "wonko_versions/edit", type: :view do
  before(:each) do
    @wonko_version = assign(:wonko_version, WonkoVersion.create!(
      :version => "",
      :type => "",
      :time => "",
      :requires => "",
      :data => "",
      :origin => ""
    ))
  end

  it "renders the edit wonko_version form" do
    render

    assert_select "form[action=?][method=?]", wonko_version_path(@wonko_version), "post" do

      assert_select "input#wonko_version_version[name=?]", "wonko_version[version]"

      assert_select "input#wonko_version_type[name=?]", "wonko_version[type]"

      assert_select "input#wonko_version_time[name=?]", "wonko_version[time]"

      assert_select "input#wonko_version_requires[name=?]", "wonko_version[requires]"

      assert_select "input#wonko_version_data[name=?]", "wonko_version[data]"

      assert_select "input#wonko_version_origin[name=?]", "wonko_version[origin]"
    end
  end
end
