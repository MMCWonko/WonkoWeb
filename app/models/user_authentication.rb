# == Schema Information
#
# Table name: user_authentications
#
#  id                         :integer          not null, primary key
#  user_id                    :integer
#  authentication_provider_id :integer
#  uid                        :string
#  token                      :string
#  token_expires_at           :datetime
#  params                     :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  provider                   :string
#
# Indexes
#
#  index_user_authentications_on_user_id  (user_id)
#

class UserAuthentication < ActiveRecord::Base
  belongs_to :user

  serialize :params

  def self.new_from_omniauth(params, user, provider)
    token_expires_at =
        params['credentials']['expires_at'] ? Time.zone.at(params['credentials']['expires_at']).to_datetime : nil

    UserAuthentication.new user: user,
                           provider: provider,
                           uid: params['uid'],
                           token: params['credentials']['token'],
                           token_expires_at: token_expires_at,
                           params: params
  end
end
