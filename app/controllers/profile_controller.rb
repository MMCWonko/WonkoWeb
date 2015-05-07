class ProfileController < ApplicationController
  before_action :set_user

  def show
    authorize @user
    set_meta_tags og: { type: 'profile', url: route(:show, @user), title: @user.username, image: @user.avatar_url,
                  username: @user.username, site_name: 'WonkoWeb' }

    # delegate to the files and versions actions to populate @wonko_{files,versions}
    files
    # versions # FIXME waiting on http://stackoverflow.com/q/30085916/953222
    @wonko_versions = WonkoVersion.all.page 0

    @activities = scope_collection PublicActivity::Activity.or({ trackable: @user },
                                                               { owner: @user },
                                                               { recipient: @user }).asc :created_at
  end

  def feed
    authorize @user, :show?
  end

  def files
    @wonko_files = scope_collection @user.wonkofiles.includes :user
    authorize @wonko_files, :index?
  end

  def versions
    @wonko_versions = scope_collection @user.related_wonkoversions
    authorize @wonko_versions, :index?
  end
end
