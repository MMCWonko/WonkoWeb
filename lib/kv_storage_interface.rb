class KVStorageInterface
  def self.implementation=(impl)
    @@impl = if impl.is_a? Symbol
               impl.constantize.new
             elsif impl.is_a? Class
               impl.new
             else
               impl
             end
  end

  def self.implementation
    @@impl
  end

  def self.set(key, value)
    @@impl.set key, value
  end

  def self.get(key)
    @@impl.get key
  end

  def set(key, value)
    fail NotImplementedError
  end

  def get(key)
    fail NotImplementedError
  end
end

class KVStorageActiveRecord
  def set(key, value)
    KVStorage.create_with(value: value).find_or_create_by key: key
  end

  def get(key)
    KVStorage.find_by(key: key).value
  end
end

KVStorageInterface.implementation = KVStorageActiveRecord
