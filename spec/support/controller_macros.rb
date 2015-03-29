module ControllerMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = Fabricate(:user)
      sign_in user
    end
  end

  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = Fabricate(:admin)
      sign_in user
    end
  end

  def login_official
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = User.find_by(username: 'Official')
      sign_in user
    end
  end
end
