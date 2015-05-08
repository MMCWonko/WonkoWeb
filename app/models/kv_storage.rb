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

class KVStorage < ActiveRecord::Base
end
