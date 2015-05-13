# == Schema Information
#
# Table name: wonko_versions
#
#  id            :integer          not null, primary key
#  version       :string
#  type          :string
#  time          :string
#  origin        :string
#  user_id       :integer
#  wonko_file_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_wonko_versions_on_user_id                                (user_id)
#  index_wonko_versions_on_version                                (version)
#  index_wonko_versions_on_wonko_file_id                          (wonko_file_id)
#  index_wonko_versions_on_wonko_file_id_and_user_id_and_version  (wonko_file_id,user_id,version) UNIQUE
#

require 'rails_helper'

RSpec.describe WonkoVersion, type: :model do
  it 'formats the time' do
    version = Fabricate(:wv_minecraft_181, time: 1_431_099_857)
    expect(version.time_as_string).to eq '2015-05-08 15:44:17'
  end
end
