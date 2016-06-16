require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do
    @user = User.new(name: "Fot", email: "ex@ut.ua",
                    password: "foobar", password_confirmation: "foobar")
  end  
  
  test "authenticated? should return false for user with  nil remember_digest" do
    assert_not @user.authenticated?('')
  end
    
  test "should valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "name shouldn't be long" do
    @user.name = "j"*51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email shouldn't be long" do
    @user.email = "j"*248 + "ex@ut.ua"
    assert_not @user.valid?
  end

  test "email validator should accept valid emails" do
    valid_emails = %w[er@rt.ua er1-2@rt.ua er@1.ua]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end  
  end

  test "email validator should reject invalid emails" do
    invalid_emails = %w[er1-2@ua er@rt,ua er1.ua]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end  
  end

  test "email should be unique" do
    user_dup = @user.dup
    user_dup.email = @user.email.upcase
    @user.save
    assert_not user_dup.valid?
  end

  test "email should be saved as downcase" do
    mixed_email = "LK5dd@KJ.ua"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be long" do
    @user.password = @user.password_confirmation = "k"*3
    assert_not @user.valid?
  end
  
  test "password shouldn't be blank" do
    @user.password = @user.password_confirmation = ""*4
    assert_not @user.valid?
  end
end
