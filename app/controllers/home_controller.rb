class HomeController < ApplicationController
  def index
    @wonko_files = WonkoFile.includes(:user).asc(:name).page params[:page]
    authorize @wonko_files
  end

  def about
    add_breadcrumb 'About', about_path
    authorize :home, :about?
  end

  def irc
    add_breadcrumb 'IRC', irc_path
    authorize :home, :irc?
  end
end
