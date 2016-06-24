require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"  
    assert_select 'input[type=file]'
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    d = assigns(:micropost)
    assert d.picture?
    follow_redirect!
    assert_match content, response.body
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    get user_path(users(:goga))
    assert_select 'a', text: "delete", count: 0
  end

  test "microposts sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "34 microposts", response.body
    #user with 0 microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "gagaga")
    get root_path
    assert_match "1 micropost", response.body
  end  
end
