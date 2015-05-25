require 'spec_helper'
require 'rails_helper'

describe HomePolicy do
  subject { described_class }

  permissions :about?, :irc? do
    it('grants access to a visitor') { is_expected.to permit(nil) }
    it('grants access to a user') { is_expected.to permit(Fabricate :user) }
    it('grants access to an admin') { is_expected.to permit(Fabricate :user_admin) }
  end
end
