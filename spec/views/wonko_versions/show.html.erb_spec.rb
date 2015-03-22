require 'rails_helper'

RSpec.describe "wonko_versions/show", type: :view do
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
