# == Schema Information
#
# Table name: wonko_origins
#
#  id          :integer          not null, primary key
#  object_id   :integer
#  object_type :string
#  origin_id   :integer
#  origin_type :string
#  data        :json
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_wonko_origins_on_object_type_and_object_id  (object_type,object_id)
#  index_wonko_origins_on_origin_type_and_origin_id  (origin_type,origin_id)
#

require 'rails_helper'

RSpec.describe WonkoOrigin, type: :model do
  describe '.assign' do
    let(:file) { Fabricate(:wf_minecraft) }
    let(:uploader) { Fabricate(:uploader, owner: file.user) }
    let :cntrllr do
      cntrllr = double 'controller'
      allow(cntrllr).to receive('current_uploader').and_return uploader
      cntrllr
    end

    it 'constructs for user' do
      allow(cntrllr).to receive('current_user').and_return file.user
      origin = described_class.assign file, cntrllr, 'asdf'
      expect(origin.object).to eq file
      expect(origin.origin).to eq file.user
      expect(origin.type).to eq 'asdf'
    end

    it 'constructs for uploader' do
      allow(cntrllr).to receive('current_user').and_return nil
      origin = described_class.assign file, cntrllr, 'asdf'
      origin.save!
      expect(origin.object).to eq file
      expect(origin.origin).to eq uploader
      expect(origin.data.deep_symbolize_keys)
        .to eq(uploader: { name: uploader.name, id: uploader.id, user_id: uploader.user_id })
    end
  end

  describe '#to_html' do
    it 'prepends "API" for uploaders using api' do
      origin = Fabricate(:wonko_origin, type: 'api', origin: Fabricate(:uploader))
      expect(origin.to_html).to eq "API (#{origin.origin.name})"
    end

    it 'gives type otherwise' do
      origin = Fabricate(:wonko_origin)
      expect(origin.to_html).to eq 'Testing'
    end
  end
end
