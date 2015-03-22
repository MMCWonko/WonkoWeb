require 'rails_helper'

RSpec.describe "wonko_files/edit", type: :view do
  before(:each) do
    @wonko_file = assign(:wonko_file, WonkoFile.create!(
      :uid => "",
      :name => ""
    ))
  end

  it "renders the edit wonko_file form" do
    render

    assert_select "form[action=?][method=?]", wonko_file_path(@wonko_file), "post" do

      assert_select "input#wonko_file_uid[name=?]", "wonko_file[uid]"

      assert_select "input#wonko_file_name[name=?]", "wonko_file[name]"
    end
  end
end
