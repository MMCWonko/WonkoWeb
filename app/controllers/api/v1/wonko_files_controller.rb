module Api
  module V1
    class WonkoFilesController < Api::ApiController
      before_action :set_wonko_file, only: [:show, :update]
      before_action :authenticate_user!, except: [:index, :show]

      def index
        authorize WonkoFile
        @wonko_files = policy_scope(WonkoFile.for_index @wur_enabled)
        fresh_when last_modified: @wonko_files.maximum(:updated_at)
      end

      def show
        authorize @wonko_file
        fresh_when @wonko_file, template: 'show'
      end

      def create
        @wonko_file = WonkoFile.new params.require(:wonko_file).permit(:uid, :name)
        @wonko_file.user = current_user
        WonkoOrigin.assign(@wonko_file, self, 'api')
        authorize @wonko_file

        if @wonko_file.save
          render 'show', status: :created if stale? @wonko_file, template: 'show'
        else
          render_json_errors @wonko_file.errors
        end
      end

      def update
        @wonko_file.assign_attributes params.require(:wonko_file).permit(:name)
        authorize @wonko_file

        if @wonko_file.save
          render 'show', status: :ok if stale? @wonko_file, template: 'show'
        else
          render_json_errors @wonko_file.errors
        end
      end
    end
  end
end
