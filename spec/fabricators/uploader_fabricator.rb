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

Fabricator(:uploader) do
  owner { Fabricate :user }
  authentication_token { sequence(:authentication_token) { |n| "asdf#{n}" } }
  name { sequence(:name) { |n| "testing#{n}" } }
  data {}
end
