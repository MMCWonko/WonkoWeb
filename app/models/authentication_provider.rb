# == Schema Information
#
# Table name: authentication_providers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_name_on_authentication_providers  (name)
#

class AuthenticationProvider < ActiveRecord::Base
  has_many :users
  has_many :user_authentications
end
