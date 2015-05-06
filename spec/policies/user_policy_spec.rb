require 'spec_helper'

describe UserPolicy do
  let(:visitor) { nil }
  let(:user) { Fabricate(:user) }
  let(:user2) { Fabricate(:user) }
  let(:admin) { Fabricate(:user_admin) }
  subject { described_class }

  permissions :create? do
    it('grants access to a visitor') { expect(subject).to permit(visitor) }
    it('rejects access to a user') { expect(subject).not_to permit(user) }
    it('rejects access to an admin') { expect(subject).not_to permit(admin) }
  end

  permissions :show? do
    it('grants access to a visitor') { expect(subject).to permit(visitor, user2) }
    it('grants access to a user') { expect(subject).to permit(user, user2) }
    it('grants access to the user') { expect(subject).to permit(user2, user2) }
    it('grants access to an admin') { expect(subject).to permit(admin, user2) }
  end

  permissions :update?, :edit? do
    it('rejects access to a visitor') { expect(subject).not_to permit(visitor, user2) }
    it('rejects access to a user') { expect(subject).not_to permit(user, user2) }
    it('grants access to the user') { expect(subject).to permit(user2, user2) }
    it('grants access to an admin') { expect(subject).to permit(admin, user2) }
  end

  permissions :destroy? do
    it('rejects access to a visitor') { expect(subject).not_to permit(visitor, user2) }
    it('rejects access to a user') { expect(subject).not_to permit(user, user2) }
    it('rejects access to the user') { expect(subject).not_to permit(user2, user2) }
    it('rejects access to an admin') { expect(subject).not_to permit(admin, user2) }
  end
end
