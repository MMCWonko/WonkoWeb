class WonkoVersionPolicy < WonkoPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
