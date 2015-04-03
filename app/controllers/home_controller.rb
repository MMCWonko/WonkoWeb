class HomeController < ApplicationController
  def index
    @wonko_files = WonkoFile.includes(:user).asc(:name).page params[:page]
  end

  def about
    add_breadcrumb 'About', about_path
  end

  def irc
    add_breadcrumb 'IRC', irc_path
  end
end
