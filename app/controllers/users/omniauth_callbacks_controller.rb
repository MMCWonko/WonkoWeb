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

    def destroy
      set_meta_tags title: 'Linked Accounts'

      authorize current_user, :update?
      auth = current_user.authentications.find_by provider: params[:provider]
      if auth
        if auth.destroy
          redirect_to user_accounts_path, notice: "Successfully unlinked #{params[:provider].titleize}"
        else
          redirect_to user_accounts_path, notice: 'There was an error'
        end
      else
        render status: 404, text: 'Provider not linked or unknown provider'
      end
    end

    private

    def create
      auth_params = request.env['omniauth.auth']
      authentication = UserAuthentication.find_by uid: auth_params.uid, provider: auth_params.provider

      if authentication
        # sign in with existing authentication
        sign_in_and_redirect :user, authentication.user
      elsif current_user
        # create authentication and sign in
        authentication = UserAuthentication.new_from_omniauth auth_params, current_user, auth_params.provider
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
