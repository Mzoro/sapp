require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  setup do
    @micropost = microposts(:orange)
  end
    
  test "should redirect create until logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Hot hot hot"} 
    end
    assert_redirected_to login_url  
  end

  test "should redirect destroy until logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost 
    end
    assert_redirected_to login_url  
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end  
end
