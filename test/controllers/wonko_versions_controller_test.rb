require 'test_helper'

class WonkoVersionsControllerTest < ActionController::TestCase
  setup do
    @wonko_version = wonko_versions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wonko_versions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wonko_version" do
    assert_difference('WonkoVersion.count') do
      post :create, wonko_version: { data: @wonko_version.data, requires: @wonko_version.requires, time: @wonko_version.time, type: @wonko_version.type, version: @wonko_version.version }
    end

    assert_redirected_to wonko_version_path(assigns(:wonko_version))
  end

  test "should show wonko_version" do
    get :show, id: @wonko_version
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wonko_version
    assert_response :success
  end

  test "should update wonko_version" do
    patch :update, id: @wonko_version, wonko_version: { data: @wonko_version.data, requires: @wonko_version.requires, time: @wonko_version.time, type: @wonko_version.type, version: @wonko_version.version }
    assert_redirected_to wonko_version_path(assigns(:wonko_version))
  end

  test "should destroy wonko_version" do
    assert_difference('WonkoVersion.count', -1) do
      delete :destroy, id: @wonko_version
    end

    assert_redirected_to wonko_versions_path
  end
end
