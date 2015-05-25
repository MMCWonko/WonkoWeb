require 'rails_helper'

RSpec.describe 'uploaders/show', type: :view do
  let(:user) { Fabricate(:user) }
  pundit_view_helpers

  before(:each) do
    @uploader = assign(:uploader, Fabricate(:uploader, owner: user))
  end

  it 'renders attributes in <p>' do
    render
  end
end
