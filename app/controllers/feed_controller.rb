class FeedController < ApplicationController
  before_action :files_crumb, only: [:file, :version]
  before_action :set_wonko_file, only: [:file, :version]
  before_action :set_wonko_version, only: :version
  before_action :set_user, only: :user

  def user
    authorize @user, :show?

    if params[:markAllRead] && @user == current_user
      Activity.mark_as_read! :all, for: current_user
      redirect_to route(:feed, @user)
      return
    end

    @activities = scope_collection Activity.related_to(@user).order(created_at: :desc)
    @activities = @activities.with_read_marks_for current_user if @user == current_user
    add_breadcrumb 'Feed', route(:feed, @user)
  end

  def file
    authorize @wonko_file, :show?
    @activities = scope_collection Activity.related_to(@wonko_file).order(created_at: :desc)
    add_breadcrumb 'Feed', route(:feed, @wonko_file)
  end

  def version
    authorize @wonko_version, :show?
    @activities = scope_collection Activity.related_to(@wonko_version).order(created_at: :desc)
    add_breadcrumb 'Feed', route(:feed, @wonko_version)
  end
end
