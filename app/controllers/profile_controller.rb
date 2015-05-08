class ProfileController < ApplicationController
  before_action :set_user

  def show
    authorize @user
    set_meta_tags og: { type: 'profile', url: route(:show, @user), title: @user.username, image: @user.avatar_url,
                  username: @user.username, site_name: 'WonkoWeb' }

    # delegate to the files and versions actions to populate @wonko_{files,versions}
    files
    versions

    @activities = scope_collection Activity.related_to(@user).order created_at: :desc
  end

  def feed
    authorize @user, :show?
  end

  def files
    @wonko_files = scope_collection @user.wonkofiles.includes :user
    authorize @wonko_files, :index?
  end

  def versions
    @wonko_versions = scope_collection WonkoVersion.related_to(@user)
    authorize @wonko_versions, :index?
  end
end
