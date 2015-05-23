module ActionController
  module RenderJsonErrors
    extend ActiveSupport::Concern

    included do
      protected

      # Usage:
      #   render_json_errors @model.errors
      #   render_json_errors title: 'Title cannot be blank',
      #                      body: [ 'To short', 'No numbers' ],
      #                      receiver: { msg: 'abc', status: 400 }
      def render_json_errors(args = {})
        errors = if args.is_a? ActiveModel::Errors
                   JsonErrorSerializer.serialize args.to_hash(true), default_status: :bad_request
                 else
                   JsonErrorSerializer.serialize args
                 end
        render json: errors, status: JsonErrorSerializer.common_status_code(errors)
      end

      def render_json_404(title, code = nil)
        render_json_errors not_found: { title: title, status: :not_found, code: code }
      end

      def render_json_403(title)
        render_json_errors forbidden: { title: title, status: :forbidden }
      end
    end
  end
end
