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

require 'rails_helper'

RSpec.describe WonkoFile, type: :model do
  let(:wonkofile) { Fabricate(:wf_minecraft) }

  it('uses the uid for its parameter') { expect(wonkofile.to_param).to eq wonkofile.uid }

  describe '#for_index' do
    let(:unofficial) { Fabricate(:wf_minecraft, user: Fabricate(:user)) }

    it 'does not give WUR files without the WUR enabled' do
      wonkofile
      unofficial
      expect(WonkoFile.for_index(false).where.not(user: User.official_user).any?).to eq false
    end

    it 'does give WUR files with the WUR enabled' do
      wonkofile
      unofficial
      expect(WonkoFile.for_index(true).where(user: User.official_user).any?).to eq true
    end
  end
end
