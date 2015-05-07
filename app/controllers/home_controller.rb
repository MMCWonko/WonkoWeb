class HomeController < ApplicationController
  def index
    @wonko_files = WonkoFile.for_index(@wur_enabled).page params[:page]
    authorize @wonko_files
    set_meta_tags canonical: route(:index, WonkoFile), title: ''
  end

  def about
    add_breadcrumb 'About', about_path
    authorize :home, :about?
    set_meta_tags title: 'About'
  end

  def irc
    add_breadcrumb 'IRC', irc_path
    authorize :home, :irc?
    set_meta_tags title: 'IRC', description: 'Connect with us on IRC!'
  end
end
