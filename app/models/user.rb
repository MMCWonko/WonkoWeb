class User
  include Mongoid::Document
  include Mongoid::Slug
  include PublicActivity::Model
  tracked

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :uid

  ## devise_uid
  field :uid, type: String
  index({ uid: 1 }, unique: true, name: 'uid_index')

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :admin, type: Boolean, default: false
  field :official, type: Boolean, default: false
  field :username, type: String

  slug :username

  has_many :wonkofiles, class_name: 'WonkoFile'

  def related_wonkoversions
    WonkoVersion.or(user: self, wonko_file: { user: self })
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
end
