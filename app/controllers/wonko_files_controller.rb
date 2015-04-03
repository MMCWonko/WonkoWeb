class WonkoFilesController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: [:index, :show]

  def index
    if @wur_enabled
      @wonko_files = WonkoFile.asc(:name).page params[:page]
    else
      @wonko_files = WonkoFile.where(user: User.official_user).asc(:name).page params[:page]
    end
    authorize @wonko_files
  end

  def show
    authorize @wonko_file
  end

  def new
    @wonko_file = WonkoFile.new
    authorize @wonko_file
    add_breadcrumb 'New', new_wonko_file_path
  end

  def edit
    authorize @wonko_file
    add_breadcrumb 'Edit', edit_wonko_file_path
  end

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

  def update
    authorize @wonko_file
    respond_to do |format|
      if !wonko_file_params.empty? && @wonko_file.update(wonko_file_params)
        format.html { redirect_to @wonko_file, notice: 'Wonko file was successfully updated.' }
        format.json { render :show, status: :ok, location: @wonko_file }
      else
        format.html { render :edit }
        format.json { render json: @wonko_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @wonko_file
    @wonko_file.destroy
    respond_to do |format|
      format.html { redirect_to wonko_files_url, notice: 'Wonko file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def wonko_file_params
    params.require(:wonko_file).permit(:uid, :name)
  end
end
