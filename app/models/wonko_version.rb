class WonkoVersion
  include Mongoid::Document

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

  validates :version, presence: true, length: { minimum: 1 }

  delegate :uid, to: :wonkofile

  def self.clean_keys(data)
    Util.deep_map_keys(data) { |key| key.sub('.', '!') }
  end
  def self.unclean_keys(data)
    Util.deep_map_keys(data) { |key| key.sub('!', '.') }
  end

  def to_param
    version
  end

  def time_as_string
    Time.at(time).to_datetime.strftime '%Y-%m-%d %H:%M'
  end

  def self.get(file, id, user = nil)
    if user
      file.wonkoversions.where(user: user).find_by(version: id)
    else
      file.wonkoversions.find_by(version: id)
    end
  rescue Mongoid::Errors::DocumentNotFound
    return nil
  end
end
