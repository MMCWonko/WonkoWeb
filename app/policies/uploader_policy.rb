class UploaderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where owner: user
    end
  end

  def show?
    super && user == record.owner
  end

  def create?
    super
  end

  def update?
    super && show?
  end

  def destroy?
    super && show?
  end
end
