class HomePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def about?
    true
  end

  def irc?
    true
  end
end
