require 'analytical'

class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for Uploader, fallback_to_devise: false
  acts_as_token_authentication_handler_for User, fallback: :none

  include Pundit
  include RoutesHelper
  include ApplicationHelper
  include PublicActivity::StoreController
  include ActionController::WonkoWeb

  analytical

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action(if: :devise_controller?) { set_meta_tags noindex: true, nofollow: true }
  before_action :handle_wur_parameter
  before_action { analytical.identify current_user.id, email: current_user.email if current_user }
  after_action :verify_authorized, if: :not_devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  add_breadcrumb 'Home', :root_path

  hide_action :authenticate_user_from_token, :authenticate_user_from_token!, :store_controller_for_public_activity,
              :form_route, :route, :pundit_policy_authorized?, :pundit_policy_scoped?

  protected

  def files_crumb
    add_breadcrumb 'Files', route(:index, WonkoFile)
  end

  def versions_crumb
    add_breadcrumb 'Versions', route(:index, @wonko_file, WonkoVersion)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :remember_me)
    end
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :username, :email, :password, :remember_me)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :current_password)
    end
  end

  def handle_wur_parameter
    if request.headers.include? 'X-WUR-Enabled'
      @wur_enabled = request.headers['X-WUR-Enabled'] == 'true'
    elsif controller_path.include? 'api/'
      @wur_enabled = params[:wur].to_s == 'true'
    else
      wur = params.key?(:wur) ? (params[:wur].to_s == 'true') : cookies[:wurEnabled]
      cookies.permanent[:wurEnabled] = wur
      @wur_enabled = wur
    end
  end

  def scope_collection(collection)
    policy_scope(collection).page params[:page]
  end

  def not_devise_controller?
    !devise_controller?
  end

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You are not allowed to perform this action' }
      format.json { render_json_403 'You are not allowed to perform this action' }
    end
  end
end
