module Api
  module V1
    class WonkoVersionsController < Api::ApiController
      before_action :set_wonko_file
      before_action :set_wonko_version, only: [:show, :update]
      before_action :authenticate_user!, except: [:index, :show]
      wrap_parameters :wonko_version, include: [:version, :type, :time, :requires, :data]

      def show
        authorize @wonko_version
        fresh_when @wonko_version, template: 'show'
      end

      def create
        @wonko_version = @wonko_file.wonkoversions.new
        @wonko_version.assign_attributes params.require(:wonko_version).permit(:version, :type, :time)
        @wonko_version.data = params.require(:wonko_version)[:data]
        @wonko_version.requires = params.require(:wonko_version)[:requires]
        @wonko_version.user = current_user
        WonkoOrigin.assign(@wonko_version, self, 'api')
        authorize @wonko_version

        if @wonko_version.save
          render 'show', status: :created if stale? @wonko_version, template: 'show'
        else
          render_json_errors @wonko_version.errors
        end
      rescue ActionController::ParameterMissing, ActionController::UnpermittedParameters
        render_json_errors bad_request: { title: 'Wrong parameters (allowed: version, type, time, requires, data)',
                                          status: :bad_request }
      end

      def update
        @wonko_version.assign_attributes params.require(:wonko_version).permit(:type, :time)
        @wonko_version.data = params.require(:wonko_version)[:data]
        @wonko_version.requires = params.require(:wonko_version)[:requires]
        authorize @wonko_version

        if @wonko_version.save
          render 'show', status: :ok if stale? @wonko_version, template: 'show'
        else
          render_json_errors @wonko_version.errors
        end
      end
    end
  end
end
