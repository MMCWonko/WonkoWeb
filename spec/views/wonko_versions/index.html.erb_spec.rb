require 'rails_helper'

RSpec.describe "wonko_versions/index", type: :view do
  before(:each) do
    assign(:wonko_versions, [
      WonkoVersion.create!(
        :version => "",
        :type => "",
        :time => "",
        :requires => "",
        :data => "",
        :origin => ""
      ),
      WonkoVersion.create!(
        :version => "",
        :type => "",
        :time => "",
        :requires => "",
        :data => "",
        :origin => ""
      )
    ])
  end

  it "renders a list of wonko_versions" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
