require 'rails_helper'

RSpec.describe 'uploaders/index', type: :view do
  let(:user) { Fabricate(:user) }
  pundit_view_helpers

  before(:each) do
    assign(:uploaders, [Fabricate(:uploader, name: 'asdf', owner: user),
                        Fabricate(:uploader, name: 'fdsa', owner: user)])
    allow(view).to receive(:current_user).and_return user
  end

  it 'renders a list of uploaders' do
    render
  end
end
