require 'rails_helper'

describe ActivityPolicy do
  let(:user) { User.new }

  subject { described_class }

  permissions :destroy?, :update? do
    it('rejects for everyone') { expect(subject).not_to permit(user, nil) }
  end
end
