require 'rails_helper'

describe ActivityPolicy do
  let(:user) { User.new }

  subject { described_class }

  permissions :destroy?, :update? do
    it('rejects for everyone') { is_expected.not_to permit(user, nil) }
  end
end
