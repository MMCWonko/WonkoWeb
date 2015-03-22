class HomeController < ApplicationController
    def index
        @wonko_files = WonkoFile.asc(:name).page params[:page]
    end
end
