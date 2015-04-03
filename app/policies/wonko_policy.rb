class WonkoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !@user.nil? && super
  end

  def update?
    @user && (@record.user == @user || @user.admin?) && super
  end

  def destroy?
    update? && super
  end
end
