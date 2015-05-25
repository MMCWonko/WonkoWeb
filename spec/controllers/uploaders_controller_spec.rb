require 'rails_helper'

RSpec.describe UploadersController, type: :controller do
  let(:valid_attributes) { Fabricate.attributes_for :uploader }
  let(:invalid_attributes) { { asdf: ' ', name: nil } }

  login_user
  let(:uploader) { Fabricate :uploader, owner: testing_user }

  describe 'GET #index' do
    it 'assigns all uploaders as @uploaders' do
      uploader
      get :index
      expect(assigns(:uploaders)).to eq([uploader])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested uploader as @uploader' do
      get :show, id: uploader.to_param
      expect(assigns(:uploader)).to eq(uploader)
    end
  end

  describe 'GET #new' do
    it 'assigns a new uploader as @uploader' do
      get :new
      expect(assigns(:uploader)).to be_a_new(Uploader)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested uploader as @uploader' do
      get :edit, id: uploader.to_param
      expect(assigns(:uploader)).to eq(uploader)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Uploader' do
        expect do
          post :create, uploader: valid_attributes
        end.to change(testing_user.uploaders, :count).by 1
      end

      it 'assigns a newly created uploader as @uploader' do
        post :create, uploader: valid_attributes
        expect(assigns(:uploader)).to be_a Uploader
        expect(assigns(:uploader)).to be_persisted
      end

      it 'redirects to the created uploader' do
        post :create, uploader: valid_attributes
        expect(response).to redirect_to Uploader.last
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved uploader as @uploader' do
        post :create, uploader: invalid_attributes
        expect(assigns(:uploader)).to be_a_new Uploader
      end

      it "re-renders the 'new' template" do
        post :create, uploader: invalid_attributes
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { data: { 'new' => 'stuff' } } }

      it 'updates the requested uploader' do
        put :update, id: uploader.to_param, uploader: new_attributes
        uploader.reload
        expect(uploader.data).to eq new_attributes[:data]
      end

      it 'assigns the requested uploader as @uploader' do
        put :update, id: uploader.to_param, uploader: valid_attributes
        expect(assigns(:uploader)).to eq uploader
      end

      it 'redirects to the uploader' do
        put :update, id: uploader.to_param, uploader: valid_attributes
        uploader.reload
        expect(response).to redirect_to uploader
      end
    end

    context 'with invalid params' do
      it 'assigns the uploader as @uploader' do
        put :update, id: uploader.to_param, uploader: invalid_attributes
        expect(assigns(:uploader)).to eq uploader
      end

      it "re-renders the 'edit' template" do
        put :update, id: uploader.to_param, uploader: invalid_attributes
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested uploader' do
      uploader
      expect do
        delete :destroy, id: uploader.to_param
      end.to change(testing_user.uploaders, :count).by(-1)
    end

    it 'redirects to the uploaders list' do
      delete :destroy, id: uploader.to_param
      expect(response).to redirect_to uploaders_url
    end
  end
end
