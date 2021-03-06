class WonkoVersionsController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, except: [:upload]
  before_action :set_wonko_version, only: [:show, :edit, :update, :destroy, :copy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wonko_versions = scope_collection @wonko_file.wonkoversions.order time: :desc
    authorize @wonko_versions
  end

  def show
    authorize @wonko_version
  end

  def new
    @wonko_version = @wonko_file.wonkoversions.build
    @wonko_version.user = current_user
    authorize @wonko_version
    versions_crumb
    add_breadcrumb 'New', route(:new, @wonko_version)
  end

  def edit
    authorize @wonko_version
    add_breadcrumb 'Edit', route(:edit, @wonko_version)
  end

  def create
    @wonko_version = @wonko_file.wonkoversions.build(wonko_version_params)
    @wonko_version.user = current_user
    WonkoOrigin.assign @wonko_version, self, 'created_from_web'
    do_respond_to :create?, 'created', @wonko_version.save, :new
  end

  def upload
    files = params[:file].is_a?(Array) ? params[:file] : [params[:file]]
    results = []

    files.each do |file|
      data = ActionController::Parameters.new(JSON.parse file.read)
      file = WonkoFile.find_by(uid: data[:uid])

      @wonko_version = WonkoVersion.find_or_create_for_data file, data, current_user
      WonkoOrigin.assign @wonko_version, self, 'uploaded_from_web'
      is_new = @wonko_version.new_record?
      authorize @wonko_version, (is_new ? :update? : :create?)

      if @wonko_version.save
        results << @wonko_version
      else
        render :new
        break
      end
    end

    return if response_body

    if results.size == 1
      redirect_to route(:show, results.first, user: results.first.user.username),
                  notice: 'Wonko version was successfully created.'
    else
      redirect_to root_path, notice: 'Wonko versions were successfully created.'
    end
  end

  def update
    do_respond_to :update?, 'updated',
                  !wonko_version_params.empty? && @wonko_version.update(wonko_version_params), :edit
  end

  def destroy
    authorize @wonko_version
    @wonko_version.delete
    redirect_to route(:index, @wonko_file, WonkoVersion),
                notice: 'Wonko version was successfully destroyed.'
  end

  def copy
    authorize @wonko_version, :show?

    unless view_context.can_copy(@wonko_version)
      redirect_to route(:show, @wonko_version, user: current_user.username),
                  notice: 'You already have this version'
      return
    end

    origin = @wonko_version.origin
    @wonko_version = @wonko_version.dup
    @wonko_version.user = current_user
    @wonko_version.origin = origin.dup
    do_respond_to :create?, 'copied', @wonko_version.save, :new
  end

  private

  def do_respond_to(action, verb, success, error_redirect)
    @wonko_version.user = current_user
    authorize @wonko_version, action

    if success
      redirect_to route(:show, @wonko_version, user: current_user.username),
                  notice: "Wonko version was successfully #{verb}."
    else
      render error_redirect
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def wonko_version_params
    params.require(:wonko_version).permit(:version, :type, :time, :requires, :data)
  end
end
