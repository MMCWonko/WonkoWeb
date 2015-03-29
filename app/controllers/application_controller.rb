class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :handle_wur_parameter

  add_breadcrumb 'Home', :root_path

  protected

  def files_crumb
    add_breadcrumb 'Files', :wonko_files_path
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

  def official_user
    User.find_by(username: 'Official')
  end

  def selected_user
    username = params[:user] || official_user.username
    @wur_enabled ? User.find_by(username: username) : official_user
  end

  def set_wonko_file
    id = params[:wonko_file_id] || params[:id]
    @wonko_file = @wur_enabled ? WonkoFile.find(id) : WonkoFile.where(user: selected_user).find(id)
    if @wonko_file
      add_breadcrumb @wonko_file.uid, wonko_file_path(@wonko_file)
      add_breadcrumb 'Versions', wonko_file_wonko_versions_path(@wonko_file)
    else
      render 'errors/404'
    end
  rescue Mongoid::Errors::DocumentNotFound
    render 'errors/404'
  end

  def set_wonko_version
    id = params[:wonko_version_id] || params[:id]
    @wonko_version = if @wur_enabled
                       @wonko_file.wonkoversions.find(id)
                     else
                       @wonko_file.wonkoversions.where(user: selected_user).find(id)
                     end
    if @wonko_version
      add_breadcrumb @wonko_version.version, wonko_file_wonko_version_path(@wonko_file, @wonko_version)
    else
      render 'errors/404'
    end
  end

  def handle_wur_parameter
    wur = params.key?(:wur) ? params[:wur] == 'true' : (cookies.permanent[:wurEnabled] || false)
    cookies.permanent[:wurEnabled] = wur
    @wur_enabled = wur
  end
end
