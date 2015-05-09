# == Schema Information
#
# Table name: kv_storages
#
#  id    :integer          not null, primary key
#  key   :string
#  value :binary
#
# Indexes
#
#  index_kv_storages_on_key  (key) UNIQUE
#

require 'rails_helper'

RSpec.describe KVStorage, type: :model do
  it 'sets and gets' do
    described_class.create!(key: 'test', value: 'asdf')
    expect(described_class.find_by key: 'test').not_to be_nil
    expect(described_class.find_by(key: 'test').value).to eq 'asdf'
  end
end
