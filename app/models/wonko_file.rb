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
  tracked owner: proc { |controller, _model| controller ? controller.current_user : nil },
          parameters: proc { |_, m| { uid: m.uid, name: m.name } }

  attr_readonly :uid

  validates :uid, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :name, presence: true, length: { minimum: 3 }
  validates :origin, presence: true

  has_many :wonkoversions, class_name: :WonkoVersion, inverse_of: :wonko_file
  has_one :origin, class_name: :WonkoOrigin, as: :object
  belongs_to :user

  paginates_per 20

  scope :for_index, -> (wur_enabled) do
    if wur_enabled
      with_wur
    else
      without_wur
    end.includes(:user).order :name
  end

  scope :with_wur, -> { all }
  scope :without_wur, -> { where(user: User.official_user) }

  def to_param
    uid
  end

  def transfer_request
    require 'activity'
    TransferRequest.requests(self).last
  end

  def request_transfer_to(target)
    create_activity :transfer_request, owner: user, recipient: target, parameters: { state: 'pending' }
  end
end
