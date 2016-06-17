require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
    @user2 = users(:goga)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect index untill logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect edit untill logged in" do
    get :edit, id: @user
    assert flash.any?
    assert_redirected_to login_url
  end  

  test "should redirect update untill logged in" do
    patch :update, id: @user, user: { name: "fgyt", email: "huy@juy.com" }
    assert flash.any?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user2)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
