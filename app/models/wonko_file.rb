class WonkoFile
  include Mongoid::Document
  include Mongoid::Slug

  field :uid, type: String
  field :name, type: String
  attr_readonly :uid

  embeds_many :wonkoversions, class_name: 'WonkoVersion'
  belongs_to :user

  paginates_per 20
  slug(&:uid)
end
