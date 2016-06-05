require 'test_helper'

class StatPagesControllerTest < ActionController::TestCase
  setup do
    @same_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "#{@same_title}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@same_title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@same_title}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{@same_title}"
  end


end
