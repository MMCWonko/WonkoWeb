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

  embedded_in :wonkofile, class_name: 'WonkoFile', inverse_of: :wonkoversions
  belongs_to :user

  paginates_per 50
  slug(&:version)

  validates :version, presence: true, length: { minimum: 1 }

  delegate :uid, to: :wonkofile

  def self.clean_keys(data)
    Util.deep_map_keys(data) { |key| key.sub('.', '!') }
  end
  def self.unclean_keys(data)
    Util.deep_map_keys(data) { |key| key.sub('!', '.') }
  end
end
