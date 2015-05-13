# == Schema Information
#
# Table name: wonko_versions
#
#  id            :integer          not null, primary key
#  version       :string
#  type          :string
#  time          :string
#  origin        :string
#  user_id       :integer
#  wonko_file_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_wonko_versions_on_user_id                                (user_id)
#  index_wonko_versions_on_version                                (version)
#  index_wonko_versions_on_wonko_file_id                          (wonko_file_id)
#  index_wonko_versions_on_wonko_file_id_and_user_id_and_version  (wonko_file_id,user_id,version) UNIQUE
#

class WonkoVersion < ActiveRecord::Base
  self.inheritance_column = nil

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller ? controller.current_user : nil }, recipient: :wonko_file

  attr_readonly :version

  belongs_to :wonko_file, class_name: :WonkoFile, inverse_of: :wonkoversions
  belongs_to :user

  paginates_per 50

  validates :version,
            presence: true,
            length: { minimum: 1 },
            uniqueness: { scope: [:wonko_file_id, :user_id], message: 'already exists' }
  validates :user, presence: true

  delegate :uid, to: :wonko_file

  def requires
    []
  end

  def data
    KVStorageInterface.get("#{uid}##{version}") || [].to_json
  end

  def data=(data)
    KVStorageInterface.set "#{uid}##{version}", data.to_json
  end

  scope :related_to, ->(user) do
    joins(:wonko_file).where('wonko_versions.user_id = :user OR wonko_files.user_id = :user', user: user)
  end

  def to_param
    version
  end

  def time_as_string
    time.nil? ? '' : Time.zone.at(time.to_i).to_datetime.strftime('%Y-%m-%d %H:%M:%S')
  end

  def self.get(file, id, user = nil)
    if user
      file.wonkoversions.where(user: user).find_by(version: id)
    else
      file.wonkoversions.find_by(version: id)
    end
  rescue ActiveRecord::RecordNotFound
    return nil
  end

  def self.find_or_create_for_data(file, data, user)
    wonko_version = file.wonkoversions.find_or_initialize_by(version: data[:version], user: user)

    wonko_version.data = data[:data]
    # wonko_version.requires = data[:requires] || []
    wonko_version.user = user
    wonko_version.update_attributes data.permit(:version, :type, :time)
    wonko_version
  end
end
