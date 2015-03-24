require 'rails_helper'

RSpec.describe 'wonko_files/show', type: :view do
  before(:each) do
    @wonko_file = assign(:wonko_file, WonkoFile.create!(
                                        uid: '',
                                        name: ''
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
