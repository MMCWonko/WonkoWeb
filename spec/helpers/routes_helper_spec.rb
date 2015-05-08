require 'rails_helper'

RSpec.describe RoutesHelper, type: :helper do
  describe 'url generation' do
    let(:file) { Fabricate(:wf_minecraft) }
    let(:version) { Fabricate(:wv_minecraft_181, wonko_file: file) }

    it 'generates show route' do
      expect(helper.route :show, file).to eq(wonko_file_path file)
    end
    it 'generates index route' do
      expect(helper.route :index, WonkoFile).to eq(wonko_files_path)
    end
    it 'generates edit route' do
      expect(helper.route :edit, file).to eq(edit_wonko_file_path file)
    end

    it 'generates nested show route' do
      expect(helper.route :show, file, version).to eq(wonko_file_wonko_version_path file, version)
    end
    it 'generates nested index route' do
      expect(helper.route :index, file, WonkoVersion).to eq(wonko_file_wonko_versions_path file)
    end
    it 'generates nested edit route' do
      expect(helper.route :edit, file, version).to eq(edit_wonko_file_wonko_version_path file, version)
    end

    it 'expands wonkoversion for show' do
      expect(helper.route :show, version).to eq(wonko_file_wonko_version_path file, version)
    end
  end
end
