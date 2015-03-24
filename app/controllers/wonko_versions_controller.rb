class WonkoVersionsController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, except: [:upload]
  before_action :set_wonko_version, only: [:show, :edit, :update, :destroy, :copy]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: [:index, :show]

  def index
    @wonko_versions = @wonko_file.wonkoversions.desc(:time).page params[:page]
  end

  def show
  end

  def new
    @wonko_version = @wonko_file.wonkoversions.build
    @wonko_version.user = current_user
    authorize @wonko_version
    add_breadcrumb 'New', new_wonko_file_wonko_version_path(@wonko_file)
  end

  def edit
    authorize @wonko_version
    add_breadcrumb @wonko_version.version, edit_wonko_file_wonko_version_path(@wonko_file, @wonko_version)
  end

  def create
    @wonko_version = @wonko_file.wonkoversions.build(wonko_version_params)
    @wonko_version.user = current_user
    authorize @wonko_version

    respond_to do |format|
      if @wonko_version.save
        format.html { redirect_to [@wonko_file, @wonko_version], notice: 'Wonko version was successfully created.' }
        format.json { render :show, status: :created, location: @wonko_version }
      else
        format.html { render :new }
        format.json { render json: @wonko_version.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload
    files = params[:file].is_a?(Array) ? params[:file] : [params[:file]]
    results = []

    files.each do |file|
      data = ActionController::Parameters.new(JSON.parse file.read)
      file = WonkoFile.find(data[:uid])

      @wonko_version = file.wonkoversions.build(data.permit(:version, :type, :time))
      @wonko_version.data = WonkoVersion.clean_keys data[:data]
      @wonko_version.requires = data[:requires] || []
      @wonko_version.user = current_user
      if file.wonkoversions.pluck(:version).include? data[:version]
        authorize @wonko_version, :update?
      else
        authorize @wonko_version, :create?
      end

      unless @wonko_version.save
        format.html { render :new }
        format.json { render json: @wonko_version.errors, status: :unprocessable_entity }
        return
      end
    end

    respond_to do |format|
      if results.size == 1
        format.html do
          redirect_to [results.first.wonkofile, results.first],
                      notice: 'Wonko version was successfully created.'
        end
        format.json { render :show, status: :created, location: @wonko_version }
      else
        format.html { redirect_to root_path, notice: 'Wonko versions were successfully created.' }
        format.json { render json: { status: :created } }
      end
    end
  end

  def update
    authorize @wonko_version
    respond_to do |format|
      if @wonko_version.update(wonko_version_params)
        format.html { redirect_to [@wonko_file, @wonko_version], notice: 'Wonko version was successfully updated.' }
        format.json { render :show, status: :ok, location: @wonko_version }
      else
        format.html { render :edit }
        format.json { render json: @wonko_version.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @wonko_version
    @wonko_version.destroy
    respond_to do |format|
      format.html do
        redirect_to wonko_file_wonko_versions_url(@wonko_file),
                    notice: 'Wonko version was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def copy
    authorize @wonko_version, :show?
    @wonko_version = @wonko_version.clone
    @wonko_version.user = current_user
    authorize @wonko_version

    respond_to do |format|
      if @wonko_version.save
        format.html { redirect_to [@wonko_file, @wonko_version], notice: 'Wonko version was successfully copied.' }
        format.json { render :show, status: :created, location: @wonko_version }
      else
        format.html { render :new }
        format.json { render json: @wonko_version.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def wonko_version_params
    params.require(:wonko_version).permit(:version, :type, :time, :requires, :data)
  end
end
