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
  slug(&:version)

  def self.clean_keys(data)
    if data.is_a? Array
      return data.map { |item| clean_keys item }
    elsif data.is_a? Hash
      return Hash[data.map { |k, v| [k.sub('.', '!'), v] }]
    else
      return data
    end
  end
  def self.unclean_keys(data)
    if data.is_a? Array
      return data.map { |item| unclean_keys item }
    elsif data.is_a? Hash
      return Hash[data.map { |k, v| [k.sub('!', '.'), v] }]
    else
      return data
    end
  end
end
