require 'rails_helper'

RSpec.describe 'uploaders/edit', type: :view do
  let(:user) { Fabricate(:user) }
  pundit_view_helpers

  before(:each) do
    @uploader = assign(:uploader, Fabricate(:uploader, owner: user))
  end

  it 'renders the edit uploader form' do
    render
  end
end
