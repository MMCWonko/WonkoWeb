# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  trackable_id   :integer
#  trackable_type :string
#  owner_id       :integer
#  owner_type     :string
#  key            :string
#  parameters     :text
#  recipient_id   :integer
#  recipient_type :string
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_activities_on_owner_id_and_owner_type          (owner_id,owner_type)
#  index_activities_on_recipient_id_and_recipient_type  (recipient_id,recipient_type)
#  index_activities_on_trackable_id_and_trackable_type  (trackable_id,trackable_type)
#

# Activity model for customisation & custom methods
class Activity < PublicActivity::Activity
  scope :related_to, ->(other) do
    return none if other.nil?
    query = "(#{where(trackable: other).where_values.map(&:to_sql).join ' AND '}) OR " +
        "(#{where(owner: other).where_values.map(&:to_sql).join ' AND '}) OR " +
        "(#{where(recipient: other).where_values.map(&:to_sql).join ' AND '})"
    where(query).includes(:trackable, :owner)
  end

  def user
    return owner if owner.is_a? User
    return recipient if recipient.is_a? User
    return trackable if trackable.is_a? User
  end
end
