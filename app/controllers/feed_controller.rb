class FeedController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, only: [:file, :version]
  before_action :set_wonko_version, only: :version
  before_action :set_user, only: :user

  def user
    authorize @user, :show?
    @activities = scope_collection Activity.related_to(@user).order(:created_at)
  end

  def file
    authorize @wonko_file, :show?
    @activities = scope_collection Activity.related_to(@user).order(:created_at)
  end

  def version
    authorize @wonko_version, :show?
    @activities = scope_collection Activity.related_to(@user).order(:created_at)
  end
end
