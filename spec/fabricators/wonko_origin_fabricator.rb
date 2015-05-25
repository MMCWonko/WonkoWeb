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

Fabricator(:wonko_origin) do
  object { Fabricate(:wf_minecraft) }
  origin { Fabricate(:user) }
  type 'testing'
end
