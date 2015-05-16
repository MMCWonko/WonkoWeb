class WonkoFilePolicy < WonkoPolicy
  def transfer?
    destroy? && (!request || request.state != :pending)
  end

  def accept_transfer?
    create? && request && request.state == :pending && (request.target == user || user.admin)
  end

  def reject_transfer?
    request && request.state == :pending && (request.target == user || user.admin)
  end

  def cancel_transfer?
    request && request.state == :pending && (request.owner == user || user.admin)
  end

  private

  def request
    record.transfer_request
  end
end
