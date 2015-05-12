class OmniauthDataHolder
  class << self
    attr_accessor :cryptor
  end

  def self.set_cryptor
    OmniauthDataHolder.cryptor ||= ActiveSupport::MessageEncryptor.new Rails.application.secrets.secret_key_base
  end

  def initialize(data)
    OmniauthDataHolder.set_cryptor
    @data = data
  end

  def data
    OmniauthDataHolder.cryptor.encrypt_and_sign @data.to_hash.to_json
  end

  def raw_data
    @data
  end

  def [](key)
    @data[key]
  end

  def self.read(encrypted)
    OmniauthDataHolder.set_cryptor
    OmniauthDataHolder.new JSON.parse(OmniauthDataHolder.cryptor.decrypt_and_verify encrypted)
  end
end
