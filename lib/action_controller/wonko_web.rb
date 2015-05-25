module ActionController
  module WonkoWeb
    include ActionController::RenderJsonErrors
    include ActionController::Setters
    include ActionController::SigninHandler
  end
end
