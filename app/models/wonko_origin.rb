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

class WonkoOrigin < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :object, polymorphic: true, inverse_of: :origin
  belongs_to :origin, polymorphic: true

  validates :origin, presence: true
  validates :type, presence: true, length: { minimum: 3 }

  before_save do
    if origin.is_a?(Uploader) && (data.nil? || data[:uploader].nil?)
      self.data = (data || {}).merge(uploader: {
                                       id: origin.id,
                                       name: origin.name,
                                       user_id: origin.user_id
                                     })
    end
  end

  def to_html
    if type == 'api' && data && data['uploader']
      'API (' + data['uploader']['name'] + ')'
    else
      type.humanize
    end
  end

  def self.assign(object, controller, type)
    origin = controller.current_user || controller.current_uploader
    object.build_origin origin: origin, type: type
  end
end
