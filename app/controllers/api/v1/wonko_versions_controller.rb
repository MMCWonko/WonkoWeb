module Api
  module V1
    class WonkoVersionsController < Api::ApiController
      before_action :set_wonko_file
      before_action :set_wonko_version, only: [:show, :update]
      before_action :authenticate_user!, except: [:index, :show]
      wrap_parameters :wonko_version, include: [:version, :type, :time, :requires, :data]

      def show
        authorize @wonko_version
      end

      def create
        @wonko_version = @wonko_file.wonkoversions.new
        @wonko_version.assign_attributes params.require(:wonko_version).permit(:version, :type, :time)
        @wonko_version.data = params.require(:wonko_version).require(:data)
        @wonko_version.requires = params.require(:wonko_version).require(:requires)
        @wonko_version.user = current_user
        authorize @wonko_version

        if @wonko_version.save
          render 'show', status: :created
        else
          render_json_errors @wonko_version.errors
        end
      end

      def update
        @wonko_version.assign_attributes params.require(:wonko_version).permit(:type, :time)
        @wonko_version.data = params.require(:wonko_version).require(:data) if params[:wonko_version][:data]
        @wonko_version.requires = params.require(:wonko_version).require(:requires) if params[:wonko_version][:requires]
        authorize @wonko_version

        if @wonko_version.save
          render 'show', status: :ok
        else
          render_json_errors @wonko_version.errors
        end
      end
    end
  end
end
