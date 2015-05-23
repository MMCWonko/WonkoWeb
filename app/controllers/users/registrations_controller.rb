module Users
  class RegistrationsController < Devise::RegistrationsController
    # before_filter :configure_sign_up_params, only: [:create]
    # before_filter :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      super
    end

    # POST /resource
    def create
      super
    end

    def accounts
    end

    def finish_signup
      @omniauth_data = OmniauthDataHolder.read params[:omniauth_data][:data] # needed if we re-render the form
      @user = User.new_from_omniauth @omniauth_data.raw_data
      @user.email = params.require(:user).permit(:email)[:email]
      @user.username = params.require(:user).permit(:username)[:username]

      begin
        @user.transaction do
          @user.save!
          @authentication = UserAuthentication.new_from_omniauth @omniauth_data.raw_data,
                                                                 @user,
                                                                 @omniauth_data['provider']
          @authentication.save!
        end
        sign_in @user
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Welcome!' }
          format.json { render json: {}, status: :created, location: route(:show, @user) }
        end
      rescue ActiveRecord::ActiveRecordError
        respond_to do |format|
          format.html { render 'finish_signup' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def reset_authentication_token
      authorize current_user, :update?
      current_user.reset_authentication_token
      respond_to do |format|
        if current_user.save
          format.html { redirect_to :back, notice: 'Authentication token successfully reset' }
          format.json { render json: {}, status: :accepted }
        else
          format.html { redirect_to :back, notice: 'There was an error while trying to reset the authentication token' }
          format.json { render json: {}, status: :not_acceptable }
        end
      end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    # You can put the params you want to permit in the empty array.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.for(:sign_up) << :attribute
    # end

    # You can put the params you want to permit in the empty array.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.for(:account_update) << :attribute
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
