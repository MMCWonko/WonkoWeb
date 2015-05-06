class ProfileController < ApplicationController
  before_action :set_user

  def show
    authorize @user
  end

  def feed
    authorize @user, :show?
  end

  def files
    @wonko_files = policy_scope @user.wonkofiles
    authorize @wonko_files, :index?
  end

  def versions
    @wonko_versions = policy_scope @user.related_wonkoversions
    authorize @wonko_versions, :index?
  end
end
