class FeedController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, only: [:file, :version]
  before_action :set_wonko_version, only: :version
  before_action :set_user, only: :user

  def user
    authorize @user, :show?
    @activities = scope_collection Activity.related_to(@user).order(created_at: :desc)
  end

  def file
    authorize @wonko_file, :show?
    @activities = scope_collection Activity.related_to(@wonko_file).order(created_at: :desc)
    add_breadcrumb 'Feed', feed_file_path(@wonko_file)
  end

  def version
    authorize @wonko_version, :show?
    @activities = scope_collection Activity.related_to(@wonko_version).order(created_at: :desc)
    add_breadcrumb 'Feed', feed_version_path(@wonko_file, @wonko_version)
  end
end
