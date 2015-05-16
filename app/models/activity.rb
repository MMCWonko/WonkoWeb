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
  acts_as_readable on: :created_at

  scope :related_to, ->(other) do
    return none if other.nil?
    query = "(#{where(trackable: other).where_values.map(&:to_sql).join ' AND '}) OR " \
        "(#{where(owner: other).where_values.map(&:to_sql).join ' AND '}) OR " \
        "(#{where(recipient: other).where_values.map(&:to_sql).join ' AND '})"
    where(query).includes(:trackable, :owner)
  end

  def user
    return owner if owner.is_a? User
    return recipient if recipient.is_a? User
    return trackable if trackable.is_a? User
  end

  def state
    parameters[:state].to_sym || :accepted if key == 'wonko_file.transfer_request'
  end
end

class TransferRequest < Activity
  alias_attribute :target, :recipient
  alias_attribute :wonko_file, :trackable

  default_scope { where key: 'wonko_file.transfer_request' }
  scope :requests, ->(file) { all.where trackable: file }

  def state=(state)
    parameters[:state] = state.to_sym
  end

  def accepted?
    state == :accepted
  end

  # stopped by the target
  def rejected?
    state == :rejected
  end

  # stopped by the owner
  def canceled?
    state == :canceled
  end

  def pending?
    state == :pending
  end

  def accept
    return false unless pending?
    request = self
    transaction do
      wonko_file.user = target
      wonko_file.save
      request.state = :accepted
      fail ActiveRecord::Rollback unless request.save
      true
    end
  end

  def reject
    return false unless pending?
    request = self
    request.state = :rejected
    request.save
  end

  def cancel
    return false unless pending?
    request = self
    request.state = :canceled
    request.save
  end
end
