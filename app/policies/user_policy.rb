class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.nil?
  end

  def update?
    user && (user.admin? || user == record) && super
  end

  def destroy?
    false
  end
end
