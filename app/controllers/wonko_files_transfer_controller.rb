class WonkoFilesTransferController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file
  before_action :set_request, except: [:transfer]

  def transfer
    authorize @wonko_file, :destroy?
    @user = User.find_by_username params[:target][:username] if params[:target]
    @user ||= User.new username: ''
    if request.method == 'GET'
      render 'wonko_files/transfer'
    else
      if @user.new_record?
        @user.errors.add(:username, 'Unknown user')
      elsif @user == @wonko_file.user
        @user.errors.add(:username, 'Attempting to transfer to current user')
      else
        @wonko_file.request_transfer_to @user
        redirect_to route(:show, @wonko_file)
      end
    end
  end

  def accept_transfer
    authorize @wonko_file, :accept_transfer?
    respond_to do |format|
      if @request.accept
        format.html { redirect_to route(:show, @wonko_file), notice: 'Congrats, you are now the owner of this file' }
        format.json { render @wonko_file }
      else
        format.html { redirect_to route(:show, @wonko_file), notice: 'Something went wrong' }
        format.json { render json: 'Something went wrong' }
      end
    end
  end

  def reject_transfer
    authorize @wonko_file, :reject_transfer?
    respond_to do |format|
      if @request.reject
        format.html { redirect_to route(:show, @wonko_file), notice: 'You rejected the transfer request' }
        format.json { render @wonko_file }
      else
        format.html { redirect_to route(:show, @wonko_file), notice: 'Something went wrong' }
        format.json { render json: 'Something went wrong' }
      end
    end
  end

  def cancel_transfer
    authorize @wonko_file, :cancel_transfer?
    respond_to do |format|
      if @request.cancel
        format.html { redirect_to route(:show, @wonko_file), notice: 'You canceled the transfer request' }
        format.json { render @wonko_file }
      else
        format.html { redirect_to route(:show, @wonko_file), notice: 'Something went wrong' }
        format.json { render json: 'Something went wrong' }
      end
    end
  end

  private

  def set_request
    @request = @wonko_file.transfer_request
    return if @request
    respond_to do |format|
      format.html { redirect_to route(:show, @wonko_file), notice: 'There is no transfer request for this file' }
      format.json { render json: 'There is no transfer request for this file', status: :not_found }
    end
  end
end
