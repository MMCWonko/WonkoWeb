require 'rails_helper'

describe UploaderPolicy do
  let(:user) { Fabricate(:user) }
  let(:other) { Fabricate(:user) }
  let(:uploader) { Fabricate(:uploader, owner: user) }

  subject { described_class }

  permissions '.scope' do
    let(:scope) { Uploader.all }
    subject(:policy_scope) { UploaderPolicy::Scope.new(user, scope).resolve }

    it 'includes only uploaders for the current user' do
      Fabricate(:uploader) # other owner
      uploaders = [uploader, Fabricate(:uploader, owner: user)]
      Fabricate(:uploader) # other owner
      expect(policy_scope).to eq uploaders
    end
  end

  permissions :show? do
    it('grants access to the owner') { is_expected.to permit(user, uploader) }
    it('denies access to someone else') { is_expected.not_to permit(other, uploader) }
  end

  permissions :create? do
    it('grants access to a user') { is_expected.to permit(user, Uploader) }
    it('denies access to a visitor') { is_expected.not_to permit(nil, Uploader) }
  end

  permissions :update? do
    it('grants access to the owner') { is_expected.to permit(user, uploader) }
    it('denies access to someone else') { is_expected.not_to permit(other, uploader) }
  end

  permissions :destroy? do
    it('grants access to the owner') { is_expected.to permit(user, uploader) }
    it('denies access to someone else') { is_expected.not_to permit(other, uploader) }
  end
end
