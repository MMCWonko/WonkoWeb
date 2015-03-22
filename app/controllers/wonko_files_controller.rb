class WonkoFilesController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: [:index, :show]

  # GET /wonko_files
  # GET /wonko_files.json
  def index
    if @wur_enabled
      @wonko_files = WonkoFile.asc(:name).page params[:page]
    else
      @wonko_files = WonkoFile.where(user: official_user).asc(:name).page params[:page]
    end
  end

  # GET /wonko_files/1
  # GET /wonko_files/1.json
  def show
  end

  # GET /wonko_files/new
  def new
    @wonko_file = WonkoFile.new
    authorize @wonko_file
    add_breadcrumb 'New', new_wonko_file_path
  end

  # GET /wonko_files/1/edit
  def edit
    authorize @wonko_file
    add_breadcrumb 'Edit', edit_wonko_file_path
  end

  # POST /wonko_files
  # POST /wonko_files.json
  def create
    @wonko_file = WonkoFile.new(wonko_file_params)
    @wonko_file.user = current_user
    authorize @wonko_file

    respond_to do |format|
      if @wonko_file.save
        format.html { redirect_to @wonko_file, notice: 'Wonko file was successfully created.' }
        format.json { render :show, status: :created, location: @wonko_file }
      else
        format.html { render :new }
        format.json { render json: @wonko_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wonko_files/1
  # PATCH/PUT /wonko_files/1.json
  def update
    authorize @wonko_file
    respond_to do |format|
      if @wonko_file.update(wonko_file_params)
        format.html { redirect_to @wonko_file, notice: 'Wonko file was successfully updated.' }
        format.json { render :show, status: :ok, location: @wonko_file }
      else
        format.html { render :edit }
        format.json { render json: @wonko_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wonko_files/1
  # DELETE /wonko_files/1.json
  def destroy
    authorize @wonko_file
    @wonko_file.destroy
    respond_to do |format|
      format.html { redirect_to wonko_files_url, notice: 'Wonko file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wonko_file
      @wonko_file = WonkoFile.find(params[:id])
      add_breadcrumb @wonko_file.uid, wonko_file_path(@wonko_file)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wonko_file_params
      params.require(:wonko_file).permit(:uid, :name)
    end
end
