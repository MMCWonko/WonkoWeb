class FeedController < ApplicationController
  before_action :files_crumb, only: [:file, :version]
  before_action :set_wonko_file, only: [:file, :version]
  before_action :set_wonko_version, only: :version
  before_action :set_user, only: [:user, :brief_user]
  skip_rack_dev_mark only: :brief_user if Rails.env.development?

  def user
    authorize @user, :show?

    if params[:markAllRead] && @user == current_user
      Activity.mark_as_read! :all, for: current_user
      redirect_to route(:feed, @user)
      return
    end

    activities_for @user
    @activities = @activities.with_read_marks_for current_user if @user == current_user
    add_breadcrumb 'Feed', route(:feed, @user)
  end

  def brief_user
    authorize @user, :show?

    activities_for @user
    @activities = @activities.limit(5).with_read_marks_for current_user if @user == current_user
    render layout: false
  end

  def file
    authorize @wonko_file, :show?
    activities_for @wonko_file
    add_breadcrumb 'Feed', route(:feed, @wonko_file)
  end

  def version
    authorize @wonko_version, :show?
    activities_for @wonko_version
    add_breadcrumb 'Feed', route(:feed, @wonko_version)
  end

  private

  def activities_for(related_to)
    @activities = scope_collection Activity.related_to(related_to).order(created_at: :desc)
  end
end
