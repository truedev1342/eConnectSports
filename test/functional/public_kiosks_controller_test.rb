require 'test_helper'

class PublicKiosksControllerTest < ActionController::TestCase
  setup do
    @public_kiosk = public_kiosks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:public_kiosks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create public_kiosk" do
    assert_difference('PublicKiosk.count') do
      post :create, public_kiosk: { background: @public_kiosk.background, background_tile: @public_kiosk.background_tile, logo: @public_kiosk.logo }
    end

    assert_redirected_to public_kiosk_path(assigns(:public_kiosk))
  end

  test "should show public_kiosk" do
    get :show, id: @public_kiosk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @public_kiosk
    assert_response :success
  end

  test "should update public_kiosk" do
    put :update, id: @public_kiosk, public_kiosk: { background: @public_kiosk.background, background_tile: @public_kiosk.background_tile, logo: @public_kiosk.logo }
    assert_redirected_to public_kiosk_path(assigns(:public_kiosk))
  end

  test "should destroy public_kiosk" do
    assert_difference('PublicKiosk.count', -1) do
      delete :destroy, id: @public_kiosk
    end

    assert_redirected_to public_kiosks_path
  end
end
