require 'rails_helper'

RSpec.describe 'uploaders/new', type: :view do
  let(:user) { Fabricate(:user) }
  pundit_view_helpers

  before(:each) do
    @uploader = assign(:uploader, Fabricate(:uploader, owner: user))
  end

  it 'renders new uploader form' do
    render
  end
end
