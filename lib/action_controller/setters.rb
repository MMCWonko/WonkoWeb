module ActionController
  module Setters
    extend ActiveSupport::Concern

    included do
      protected

      def selected_user
        username = params[:user] || User.official_user.username
        @wur_enabled ? User.find_by(username: username) : User.official_user
      rescue ActiveRecord::RecordNotFound
        nil
      end

      def set_wonko_file
        id = params[:wonko_file_id] || params[:id]
        id = id.sub(/\.json$/, '')

        @wonko_file = WonkoFile.find_by(uid: id)
        fail ActiveRecord::RecordNotFound if @wonko_file.nil?

        if @wur_enabled || @wonko_file.user == User.official_user
          add_breadcrumb @wonko_file.uid, route(:show, @wonko_file)
          set_meta_tags title: @wonko_file.name, author: route(:show, @wonko_file.user)
        else
          respond_to do |format|
            format.html { render 'wonko_files/enable_wur', status: :not_found }
            format.json do
              render_json_404 'No Wonko file for the specified UID found. What you want exists in the WUR though',
                              :wonkofile_404_in_wur
            end
          end
        end
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { render 'errors/404', status: :not_found }
          format.json { render_json_404 'No Wonko file found for the given UID' }
        end
      end

      def set_wonko_version
        id = params[:wonko_version_id] || params[:id]
        id = id.sub(/\.json$/, '')

        @wonko_version = selected_user ? WonkoVersion.get(@wonko_file, id, selected_user) : nil

        # if we haven't specifically asked for a user we can take any
        if !@wonko_version && @wur_enabled && @wonko_file.wonkoversions.where(version: id).count == 1
          @wonko_version = WonkoVersion.get(@wonko_file, id)
        end

        if @wonko_version
          versions_crumb
          add_breadcrumb @wonko_version.version, route(:show, @wonko_version)
          set_meta_tags title: "#{@wonko_version.version} (#{@wonko_file.name})",
                        author: route(:show, @wonko_version.user)
        else
          @wonko_versions = @wonko_file.wonkoversions.where(version: id)
          respond_to_wonko_version
        end
      end

      def set_user
        @user = params.key?(:username) ? User.find_by(username: params[:username]) : current_user
        fail ActiveRecord::RecordNotFound unless @user
        add_breadcrumb @user.username, route(:show, @user)
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { render 'errors/404', status: :not_found }
          format.json { render_json_404 'User not found' }
        end
      end

      private

      def respond_to_wonko_version
        respond_to do |format|
          if @wonko_versions.empty?
            format.html { render 'errors/404', status: :not_found }
            format.json { render_json_404 'No Wonko version found for the given UID/version' }
          elsif @wur_enabled || selected_user != User.official_user
            format.html { render 'wonko_versions/list_of_variants' }
            format.json do
              render_json_404 'The requested version is available from several users, please specify which to use.',
                              :wonkoversion_404_multiple
            end
          else # not empty but wur disabled
            format.html { render 'wonko_files/enable_wur', status: :not_found }
            format.json do
              render_json_404 'No version for the specified UID/version found. What you want exists in the WUR though.',
                              :wonkoversion_404_in_wur
            end
          end
        end
      end
    end
  end
end
