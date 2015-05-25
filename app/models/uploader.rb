# == Schema Information
#
# Table name: uploaders
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  authentication_token :string
#  name                 :string
#  data                 :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_uploaders_on_authentication_token  (authentication_token) UNIQUE
#  index_uploaders_on_user_id               (user_id)
#

class Uploader < ActiveRecord::Base
  belongs_to :owner, class_name: :User, foreign_key: :user_id

  acts_as_token_authenticatable
  def reset_authentication_token
    self.authentication_token = nil
  end

  validates :owner, presence: true
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :authentication_token, uniqueness: true

  def to_param
    name
  end
end
