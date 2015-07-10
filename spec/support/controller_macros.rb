module ControllerMacros
  def login_testing_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = testing_user
      user.confirm
      sign_in user
    end
  end

  def login_user
    let(:testing_user) { Fabricate(:user) }
    login_testing_user
  end

  def login_admin
    let(:testing_user) { Fabricate(:admin) }
    login_testing_user
  end

  def login_official
    let(:testing_user) { User.official_user }
    login_testing_user
  end
end
