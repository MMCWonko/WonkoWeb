SimpleTokenAuthentication.configure do |config|
  config.identifiers = {
    user: :email,
    uploader: :name
  }
end
