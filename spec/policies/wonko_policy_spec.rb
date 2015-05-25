require 'spec_helper'
require 'rails_helper'

describe WonkoPolicy do
  let(:visitor) { nil }
  let(:user) { Fabricate(:user) }
  let(:owner) { Fabricate(:user) }
  let(:admin) { Fabricate(:user_admin) }
  let(:wonkofile) { Fabricate(:wf_minecraft, user: owner) }
  subject { described_class }

  permissions :show? do
    it('grants access to a visitor') { is_expected.to permit(visitor, wonkofile) }
    it('grants access to a user') { is_expected.to permit(user, wonkofile) }
    it('grants access to the owner') { is_expected.to permit(owner, wonkofile) }
    it('grants access to a admin') { is_expected.to permit(admin, wonkofile) }
  end

  permissions :create?, :new? do
    it('denies access to a visitor') { is_expected.not_to permit(visitor, WonkoFile) }
    it('grants access to a user') { is_expected.to permit(user, WonkoFile) }
    it('grants access to the owner') { is_expected.to permit(owner, WonkoFile) }
    it('grants access to a admin') { is_expected.to permit(admin, WonkoFile) }
  end

  permissions :update?, :edit?, :destroy? do
    it('denies access to a visitor') { is_expected.not_to permit(visitor, wonkofile) }
    it('denies access to a user') { is_expected.not_to permit(user, wonkofile) }
    it('grants access to the owner') { is_expected.to permit(owner, wonkofile) }
    it('grants access to a admin') { is_expected.to permit(admin, wonkofile) }
  end
end
