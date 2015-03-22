class WonkoVersion
  include Mongoid::Document
  include Mongoid::Slug
  
  field :version, type: String
  field :type, type: String
  field :time, type: Integer
  field :requires, type: Array
  field :data, type: Array
  field :origin, type: String
  attr_readonly :version
  
  embedded_in :wonkofile, class_name: 'WonkoFile'
  belongs_to :user
  
  paginates_per 50
  slug do |obj| obj.version end
  
  def self.clean_keys(data)
    if data.is_a? Array
      return data.map do |item| self.clean_keys item end
    elsif data.is_a? Hash
      return Hash[data.map do |k, v| [k.sub('.', '!'), v] end]
    else
      return data
    end
  end
  def self.unclean_keys(data)
    if data.is_a? Array
      return data.map do |item| self.unclean_keys item end
    elsif data.is_a? Hash
      return Hash[data.map do |k, v| [k.sub('!', '.'), v] end]
    else
      return data
    end
  end
end
