module Api
  class ApiController < ApplicationController
    before_action :ensure_format_is_json
    protect_from_forgery with: :null_session

    protected

    def ensure_format_is_json
      return if params[:format].to_sym == :json
      render_json_errors invalid_format: {
        title: 'Only the JSON format is currently supported for the API',
        status: :bad_request
      }
    end
  end
end
