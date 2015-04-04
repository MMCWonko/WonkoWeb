class ApplicationController < ActionController::Base
  include Pundit
  include RoutesHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :handle_wur_parameter
  after_action :verify_authorized

  add_breadcrumb 'Home', :root_path

  protected

  def files_crumb
    add_breadcrumb 'Files', route(:index, WonkoFile)
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

  def selected_user
    username = params[:user] || User.official_user.username
    @wur_enabled ? User.find_by(username: username) : User.official_user
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def set_wonko_file
    id = params[:wonko_file_id] || params[:id]
    @wonko_file = WonkoFile.find_by(uid: id)

    if @wur_enabled || @wonko_file.user == User.official_user
      add_breadcrumb @wonko_file.uid, route(:show, @wonko_file)
      add_breadcrumb 'Versions', route(:index, @wonko_file, WonkoVersion)
    else
      render 'wonko_files/enable_wur'
    end
  rescue Mongoid::Errors::DocumentNotFound
    render 'errors/404'
  end

  def set_wonko_version
    id = params[:wonko_version_id] || params[:id]

    @wonko_version = selected_user ? WonkoVersion.get(@wonko_file, id, selected_user) : nil

    # if we haven't specifically asked for a user we can take any
    if !@wonko_version && @wur_enabled && @wonko_file.wonkoversions.where(version: id).count == 1
      @wonko_version = WonkoVersion.get(@wonko_file, id)
    end

    if @wonko_version
      add_breadcrumb @wonko_version.version, route(:show, @wonko_version)
    else
      @wonko_versions = @wonko_file.wonkoversions.where(version: id)
      if @wonko_versions.empty?
        render 'errors/404'
      else
        render 'wonko_versions/list_of_variants'
      end
    end
  end

  def set_user
    @user = params.key? :username ? User.find_by(username: params[:username]) : current_user
    render 'errors/404' unless @user
  rescue Mongoid::Errors::DocumentNotFound
    render 'errors/404'
  end

  def handle_wur_parameter
    wur = params.key?(:wur) ? params[:wur].to_s == 'true' : (cookies.permanent[:wurEnabled] || false)
    cookies.permanent[:wurEnabled] = wur
    @wur_enabled = wur
  end
end
