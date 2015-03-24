class WonkoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !@user.nil?
  end

  def update?
    @user && (@record.user == @user || @user.admin?)
  end

  def destroy?
    update?
  end
end
