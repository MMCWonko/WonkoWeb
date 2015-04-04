class FeedController < ApplicationController
  before_action :files_crumb
  before_action :set_wonko_file, only: [:file, :version]
  before_action :set_wonko_version, only: :version
  before_action :set_user, only: :user

  def user
    authorize @user, :show?
  end

  def file
    authorize @wonko_file, :show?
  end

  def version
    authorize @wonko_version, :show?
  end
end
