require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "right signup info" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Nm",
                               email: "user@invalid.com",
                               password:              "foo0",
                               password_confirmation: "foo0" }
    end
    assert_template 'users/show'
    assert flash.any?
  end  
end
