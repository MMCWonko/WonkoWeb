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

RSpec.describe KvStorage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
