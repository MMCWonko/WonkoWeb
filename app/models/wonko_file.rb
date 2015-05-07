class WonkoFile
  include Mongoid::Document
  include Mongoid::Timestamps
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller ? controller.current_user : nil }

  field :uid, type: String
  field :name, type: String
  attr_readonly :uid

  validates :uid, presence: true, length: { minimum: 4 }, uniqueness: true
  validates :name, presence: true, length: { minimum: 4 }

  embeds_many :wonkoversions, class_name: 'WonkoVersion', inverse_of: :wonkofile
  belongs_to :user

  paginates_per 20

  scope :for_index, -> (wur_enabled) do
    if wur_enabled
      includes(:user).asc(:name)
    else
      includes(:user).where(user: User.official_user).asc(:name)
    end
  end

  include Mongoid::History::Trackable
  track_history modifier_field: 'User', version_field: :revision, track_create: true, track_update: true, track_destroy: true

  def to_param
    uid
  end
end
