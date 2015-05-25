require 'spec_helper'

describe UserPolicy do
  let(:visitor) { nil }
  let(:user) { Fabricate(:user) }
  let(:user2) { Fabricate(:user) }
  let(:admin) { Fabricate(:user_admin) }
  subject { described_class }

  permissions :create? do
    it('grants access to a visitor') { is_expected.to permit(visitor) }
    it('rejects access to a user') { is_expected.not_to permit(user) }
    it('rejects access to an admin') { is_expected.not_to permit(admin) }
  end

  permissions :show? do
    it('grants access to a visitor') { is_expected.to permit(visitor, user2) }
    it('grants access to a user') { is_expected.to permit(user, user2) }
    it('grants access to the user') { is_expected.to permit(user2, user2) }
    it('grants access to an admin') { is_expected.to permit(admin, user2) }
  end

  permissions :update?, :edit? do
    it('rejects access to a visitor') { is_expected.not_to permit(visitor, user2) }
    it('rejects access to a user') { is_expected.not_to permit(user, user2) }
    it('grants access to the user') { is_expected.to permit(user2, user2) }
    it('grants access to an admin') { is_expected.to permit(admin, user2) }
  end

  permissions :destroy? do
    it('rejects access to a visitor') { is_expected.not_to permit(visitor, user2) }
    it('rejects access to a user') { is_expected.not_to permit(user, user2) }
    it('rejects access to the user') { is_expected.not_to permit(user2, user2) }
    it('rejects access to an admin') { is_expected.not_to permit(admin, user2) }
  end
end
