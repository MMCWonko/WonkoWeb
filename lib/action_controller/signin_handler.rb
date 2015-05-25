module ActionController
  module SigninHandler
    extend ActiveSupport::Concern

    included do
      attr_accessor :current_uploader
    end

    class SignInHandler < SimpleTokenAuthentication::SignInHandler
      def sign_in(controller, record, *args)
        controller.current_uploader = record.is_a?(Uploader) ? record : nil
        super controller, (record.is_a?(User) ? record : record.owner), *args
      end
    end

    def sign_in_handler
      @sign_in_handler ||= SignInHandler.new
    end
  end
end
