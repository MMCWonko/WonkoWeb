class UploadersController < ApplicationController
  before_action :set_uploader, only: [:show, :edit, :update, :destroy, :reset_token]

  def index
    authorize Uploader
    @uploaders = policy_scope current_user.uploaders
  end

  def show
    authorize @uploader
  end

  def new
    @uploader = current_user.uploaders.new
    authorize @uploader
  end

  def edit
    authorize @uploader
  end

  def create
    @uploader = current_user.uploaders.new uploader_params
    authorize @uploader

    if @uploader.save
      redirect_to @uploader, notice: 'Uploader was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @uploader
    if @uploader.update(uploader_params)
      redirect_to @uploader, notice: 'Uploader was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @uploader
    @uploader.destroy
    redirect_to uploaders_url, notice: 'Uploader was successfully destroyed.'
  end

  def reset_token
    authorize @uploader, :update?
    @uploader.reset_authentication_token
    if @uploader.save
      redirect_to route(:edit, @uploader), notice: 'Authentication token successfully reset'
    else
      redirect_to route(:edit, @uploader), notice: 'There was an error while trying to reset the authentication token'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_uploader
    @uploader = current_user.uploaders.find_by name: params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def uploader_params
    params.require(:uploader).permit(:name).tap do |whitelisted|
      whitelisted[:data] = params[:uploader][:data]
    end
  end
end
