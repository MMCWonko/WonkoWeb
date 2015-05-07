class FeedController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, only: [:file, :version]
  before_action :set_wonko_version, only: :version
  before_action :set_user, only: :user

  def user
    authorize @user, :show?
    @activities = scope_collection PublicActivity::Activity.or(trackable: @user,
                                                               owner: @user,
                                                               recipient: @user).asc(:created_at)
  end

  def file
    authorize @wonko_file, :show?
    @activities = scope_collection PublicActivity::Activity.or(trackable: @wonko_file,
                                                               owner: @wonko_file,
                                                               recipient: @wonko_file).asc(:created_at)
  end

  def version
    authorize @wonko_version, :show?
    @activities = scope_collection PublicActivity::Activity.or(trackable: @wonko_version,
                                                               owner: @wonko_version,
                                                               recipient: @wonko_version).asc(:created_at)
  end
end
