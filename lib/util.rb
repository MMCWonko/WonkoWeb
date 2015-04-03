module Util
  def self.deep_map_keys(val, &block)
    if val.is_a? Array
      val.map { |item| deep_map_keys item, &block }
    elsif val.is_a? Hash
      Hash[val.map { |k, v| [yield(k), deep_map_keys(v, &block)] }]
    else
      val
    end
  end
end
