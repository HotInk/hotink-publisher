require 'test_helper'

class FrontPagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:front_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create front_page" do
    assert_difference('FrontPage.count') do
      post :create, :front_page => { }
    end

    assert_redirected_to front_page_path(assigns(:front_page))
  end

  test "should show front_page" do
    get :show, :id => front_pages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => front_pages(:one).to_param
    assert_response :success
  end

  test "should update front_page" do
    put :update, :id => front_pages(:one).to_param, :front_page => { }
    assert_redirected_to front_page_path(assigns(:front_page))
  end

  test "should destroy front_page" do
    assert_difference('FrontPage.count', -1) do
      delete :destroy, :id => front_pages(:one).to_param
    end

    assert_redirected_to front_pages_path
  end
end
