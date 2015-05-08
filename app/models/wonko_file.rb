# == Schema Information
#
# Table name: wonko_files
#
#  id         :integer          not null, primary key
#  uid        :string
#  name       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_wonko_files_on_uid      (uid) UNIQUE
#  index_wonko_files_on_user_id  (user_id)
#

class WonkoFile < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller ? controller.current_user : nil }

  attr_readonly :uid

  validates :uid, presence: true, length: { minimum: 4 }, uniqueness: true
  validates :name, presence: true, length: { minimum: 4 }

  has_many :wonkoversions, class_name: :WonkoVersion, inverse_of: :wonko_file
  belongs_to :user

  paginates_per 20

  scope :for_index, -> (wur_enabled) do
    if wur_enabled
      with_wur.includes(:user).order(:name)
    else
      without_wur.includes(:user).order(:name)
    end
  end

  scope :with_wur, -> { all }
  scope :without_wur, -> { where(user: User.official_user) }

  def to_param
    uid
  end
end
