# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  uid                    :string
#  admin                  :boolean          default(FALSE)
#  official               :boolean          default(FALSE)
#  username               :string
#  authentication_token   :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  acts_as_reader

  acts_as_token_authenticatable
  def reset_authentication_token
    self.authentication_token = nil
  end

  devise :omniauthable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :uid, :async,
         authentication_keys: [:login]

  has_many :wonkofiles, class_name: :WonkoFile
  has_many :wonkoversions, class_name: :WonkoVersion
  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    else
      find_by(conditions)
    end
  end

  def notifications
    Activity.related_to(self).unread_by(self).order created_at: :desc
  end

  def self.official_user
    User.find_by(official: true)
  end

  def to_param
    username
  end

  def avatar_url
    Gravatar.new(email).image_url
  end

  def self.new_from_omniauth(params)
    info = params['info']
    email = info['email']
    password = Devise.friendly_token[0, 20]
    User.new username: params['extra']['raw_info']['username'] || info['nickname'] || params['uid'],
             email: email || '',
             password: password,
             password_confirmation: password
  end
end
