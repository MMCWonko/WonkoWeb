require 'rails_helper'
require 'pry'

RSpec.describe WonkoFilesController, type: :controller do
  let(:valid_attributes) { Fabricate.attributes_for(:wf_minecraft) }

  let(:invalid_attributes) do
    {
      user: '',
      asdf: [],
      wonkoversions: []
    }
  end

  describe 'GET #index' do
    login_user

    it 'assigns all wonko_files as @wonko_files' do
      wonko_file = Fabricate(:wf_minecraft)
      get :index, {}
      expect(assigns(:wonko_files).to_a).to eq([wonko_file])
    end
  end

  describe 'GET #show' do
    login_user

    it 'assigns the requested wonko_file as @wonko_file' do
      wonko_file = Fabricate(:wf_minecraft)
      get :show, id: wonko_file.to_param
      expect(assigns(:wonko_file)).to eq(wonko_file)
    end
  end

  describe 'GET #new' do
    login_user

    it 'assigns a new wonko_file as @wonko_file' do
      get :new, {}
      expect(assigns(:wonko_file)).to be_a_new(WonkoFile)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested wonko_file as @wonko_file' do
      wonko_file = Fabricate(:wf_minecraft)
      sign_in wonko_file.user
      get :edit, id: wonko_file.to_param
      expect(assigns(:wonko_file)).to eq(wonko_file)
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid params' do
      it 'creates a new WonkoFile' do
        expect do
          post :create, wonko_file: Fabricate.attributes_for(:wf_minecraft)
        end.to change(WonkoFile, :count).by(1)
      end

      it 'assigns a newly created wonko_file as @wonko_file' do
        post :create, wonko_file: Fabricate.attributes_for(:wf_minecraft)
        expect(assigns(:wonko_file)).to be_a(WonkoFile)
        expect(assigns(:wonko_file)).to be_persisted
      end

      it 'redirects to the created wonko_file' do
        post :create, wonko_file: Fabricate.attributes_for(:wf_minecraft)
        expect(response).to redirect_to(WonkoFile.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved wonko_file as @wonko_file' do
        post :create, wonko_file: invalid_attributes
        expect(assigns(:wonko_file)).to be_a_new(WonkoFile)
      end

      it "re-renders the 'new' template" do
        post :create, wonko_file: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Not-Minecraft'
        }
      end

      it 'updates the requested wonko_file' do
        wonko_file = Fabricate(:wf_minecraft)
        sign_in wonko_file.user

        put :update, id: wonko_file.to_param, wonko_file: new_attributes
        wonko_file.reload
        expect(wonko_file.name).to eq 'Not-Minecraft'
      end

      it 'assigns the requested wonko_file as @wonko_file' do
        wonko_file = Fabricate(:wf_minecraft)
        sign_in wonko_file.user

        put :update, id: wonko_file.to_param, wonko_file: valid_attributes
        expect(assigns(:wonko_file)).to eq(wonko_file)
      end

      it 'redirects to the wonko_file' do
        wonko_file = Fabricate(:wf_minecraft)
        sign_in wonko_file.user

        put :update, id: wonko_file.to_param, wonko_file: valid_attributes
        expect(response).to redirect_to(wonko_file)
      end
    end

    context 'with invalid params' do
      it 'assigns the wonko_file as @wonko_file' do
        wonko_file = Fabricate(:wf_minecraft)
        sign_in wonko_file.user

        put :update, id: wonko_file.to_param, wonko_file: invalid_attributes
        expect(assigns(:wonko_file)).to eq(wonko_file)
      end

      it "re-renders the 'edit' template" do
        wonko_file = Fabricate(:wf_minecraft)
        sign_in wonko_file.user

        put :update, id: wonko_file.to_param, wonko_file: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested wonko_file' do
      wonko_file = Fabricate(:wf_minecraft)
      sign_in wonko_file.user

      expect do
        delete :destroy, id: wonko_file.to_param
      end.to change(WonkoFile, :count).by(-1)
    end

    it 'redirects to the wonko_files list' do
      wonko_file = Fabricate(:wf_minecraft)
      sign_in wonko_file.user

      delete :destroy, id: wonko_file.to_param
      expect(response).to redirect_to(wonko_files_url)
    end
  end
end
