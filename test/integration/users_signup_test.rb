require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "error messages" do
    user = User.new(name: "",
                    email: "user@invalid",
                    password:              "foo",
                    password_confirmation: "foo")
    user.save
    assert_equal user.errors.full_messages, ["Name can't be blank", "Email is invalid", "Password is too short (minimum is 4 characters)"]

  end

  test "wrong signup info" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert flash.empty?
  end

  test "right signup info with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Nm",
                               email: "user@invalid.com",
                               password:              "foo0",
                               password_confirmation: "foo0" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert flash.any?
  end  
end
