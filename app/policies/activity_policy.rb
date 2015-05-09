class ActivityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    trackable_policy.show? &&
      owner_policy.show? &&
      recipient_policy.show?
  end

  def create?
    show?
  end

  def update?
    false
  end

  def destroy?
    false
  end

  private

  def trackable_policy
    Pundit.policy user, record.trackable
  end

  def owner_policy
    Pundit.policy user, record.owner
  end

  def recipient_policy
    Pundit.policy user, record.recipient
  end
end
