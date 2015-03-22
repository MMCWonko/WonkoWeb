class WonkoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?
    not @user == nil
  end
  
  def update?
    @user and (@record.user == @user or @user.admin?)
  end
  
  def destroy?
    update?
  end
end
