require 'analytical'

class ApplicationController < ActionController::Base
  include Pundit
  include RoutesHelper
  include PublicActivity::StoreController

  analytical

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :noindex_logins, if: :devise_controller?
  before_action :handle_wur_parameter
  before_action :identify_user
  after_action :verify_authorized, if: :not_devise_controller?

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

  def noindex_logins
    set_meta_tags noindex: true, nofollow: true
  end

  def selected_user
    username = params[:user] || User.official_user.username
    @wur_enabled ? User.find_by(username: username) : User.official_user
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def set_wonko_file
    id = params[:wonko_file_id] || params[:id]
    @wonko_file = WonkoFile.find_by(uid: id)
    fail ActiveRecord::RecordNotFound if @wonko_file.nil?

    if @wur_enabled || @wonko_file.user == User.official_user
      add_breadcrumb @wonko_file.uid, route(:show, @wonko_file)
      add_breadcrumb 'Versions', route(:index, @wonko_file, WonkoVersion)
      set_meta_tags title: @wonko_file.name, author: route(:show, @wonko_file.user)
    else
      render 'wonko_files/enable_wur'
    end
  rescue ActiveRecord::RecordNotFound
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
      set_meta_tags title: "#{@wonko_version.version} (#{@wonko_file.name})", author: route(:show, @wonko_version.user)
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
    @user = params.key?(:username) ? User.find_by(username: params[:username]) : current_user
    render 'errors/404' unless @user
  rescue ActiveRecord::RecordNotFound
    render 'errors/404'
  end

  def handle_wur_parameter
    wur = params.key?(:wur) ? params[:wur].to_s == 'true' : (cookies.permanent[:wurEnabled] || false)
    cookies.permanent[:wurEnabled] = wur
    @wur_enabled = wur
  end

  def identify_user
    analytical.identify current_user.id, email: current_user.email if current_user
  end

  def scope_collection(collection)
    policy_scope(collection).page params[:page]
  end

  def not_devise_controller?
    !devise_controller?
  end
end
