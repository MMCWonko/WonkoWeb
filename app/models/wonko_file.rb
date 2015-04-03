class WonkoFile
  include Mongoid::Document

  field :uid, type: String
  field :name, type: String
  attr_readonly :uid

  validates :uid, presence: true, length: { minimum: 4 }, uniqueness: true
  validates :name, presence: true, length: { minimum: 4 }

  embeds_many :wonkoversions, class_name: 'WonkoVersion', inverse_of: :wonkofile
  belongs_to :user

  paginates_per 20

  def to_param
    uid
  end
end
