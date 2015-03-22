require 'test_helper'

class WonkoFilesControllerTest < ActionController::TestCase
  setup do
    @wonko_file = wonko_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wonko_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wonko_file" do
    assert_difference('WonkoFile.count') do
      post :create, wonko_file: { name: @wonko_file.name, uid: @wonko_file.uid }
    end

    assert_redirected_to wonko_file_path(assigns(:wonko_file))
  end

  test "should show wonko_file" do
    get :show, id: @wonko_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wonko_file
    assert_response :success
  end

  test "should update wonko_file" do
    patch :update, id: @wonko_file, wonko_file: { name: @wonko_file.name, uid: @wonko_file.uid }
    assert_redirected_to wonko_file_path(assigns(:wonko_file))
  end

  test "should destroy wonko_file" do
    assert_difference('WonkoFile.count', -1) do
      delete :destroy, id: @wonko_file
    end

    assert_redirected_to wonko_files_path
  end
end
