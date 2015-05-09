class KVStorageInterface
  class << self
    attr_accessor :impl
  end

  def self.implementation=(impl)
    KVStorageInterface.impl = if impl.is_a? Symbol
                                impl.constantize.new
                              elsif impl.is_a? Class
                                impl.new
                              else
                                impl
                              end
  end

  def self.implementation
    KVStorageInterface.impl
  end

  def self.set(key, value)
    KVStorageInterface.impl.set key, value
  end

  def self.get(key)
    KVStorageInterface.impl.get key
  end

  def set(_key, _value)
    fail NotImplementedError
  end

  def get(_key)
    fail NotImplementedError
  end
end

class KVStorageActiveRecord
  def set(key, value)
    KVStorage.create_with(value: value).find_or_create_by key: key
  end

  def get(key)
    model = KVStorage.find_by(key: key)
    model.value unless model.nil?
  end
end

KVStorageInterface.implementation = KVStorageActiveRecord
