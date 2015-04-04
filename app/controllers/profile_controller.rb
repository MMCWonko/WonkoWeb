class ProfileController < ApplicationController
  before_action :set_user

  def show
    authorize @user
  end

  def feed
    authorize @user, :show?
  end

  def files
    authorize @wonko_files, :index?
  end

  def versions
    authorize @wonko_versions, :index?
  end
end
