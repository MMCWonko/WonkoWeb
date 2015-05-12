module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      create
    end

    def github
      create
    end

    def steam
      create
    end

    private

    def create
      auth_params = request.env['omniauth.auth']
      provider = AuthenticationProvider.find_by name: auth_params.provider
      authentication = provider.user_authentications.where(uid: auth_params.uid).first

      if authentication
        # sign in with existing authentication
        sign_in_and_redirect :user, authentication.user
      elsif current_user
        # create authentication and sign in
        authentication = UserAuthentication.new_from_omniauth(auth_params, current_user, provider)
        if authentication.save
          sign_in_and_redirect :user, current_user
        else
          redirect_to new_user_registration, notice: "Error while authenticating with #{auth_params.provider.titlecase}"
        end
      else
        # ask the user for additional info
        @omniauth_data = OmniauthDataHolder.new auth_params
        @user = User.new_from_omniauth auth_params
        render 'devise/registrations/finish_signup'
      end
    end
  end
end
