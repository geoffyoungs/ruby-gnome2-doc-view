require 'test_helper'

class BrowseControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get view" do
    get :view
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
