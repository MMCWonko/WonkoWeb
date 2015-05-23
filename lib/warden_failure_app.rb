class WardenFailureApp < Devise::FailureApp
  def http_auth_body
    if request_format.to_sym == :json
      JsonErrorSerializer.serialize(auth: { title: i18n_message, status: 401 }).to_json
    else
      super
    end
  end
end
