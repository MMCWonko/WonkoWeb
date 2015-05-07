class WonkoVersion
  include Mongoid::Document
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| binding.pry; controller ? controller.current_user : nil }

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
    time.nil? ? '' : Time.zone.at(time).to_datetime.strftime('%Y-%m-%d %H:%M')
  end

  include Mongoid::History::Trackable
  track_history modifier_field: 'User', version_field: :revision, track_create: true, track_update: true, track_destroy: true

  def self.get(file, id, user = nil)
    if user
      file.wonkoversions.where(user: user).find_by(version: id)
    else
      file.wonkoversions.find_by(version: id)
    end
  rescue Mongoid::Errors::DocumentNotFound
    return nil
  end

  def self.find_or_create_for_data(file, data, user)
    wonko_version = file.wonkoversions.find_or_initialize_by(version: data[:version], user: user)

    wonko_version.data = WonkoVersion.clean_keys data[:data]
    wonko_version.requires = data[:requires] || []
    wonko_version.user = user
    wonko_version.update_attributes data.permit(:version, :type, :time)
    wonko_version
  end
end
