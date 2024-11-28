require 'test_helper'

class LikingRelationsNotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @relation = liking_relations(:one_likes_two)
  end
end

class LikingRelationsNotLoggedInTest < LikingRelationsNotLoggedIn

  test 'should redirect create if not logged in' do
    post liking_relations_path
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning'
  end

  test 'should redirect destroy if not logged in' do
    delete liking_relation_path(@relation)
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning'
  end
end

class LikingRelationsLoggedInTest < LikingRelationsNotLoggedIn

  def setup
    super
    @user = users(:dwight)
    login_as(@user)
  end

  test 'should redirect destroy if not the right user' do
    delete liking_relation_path(@relation)
    assert_redirected_to root_url
    assert_response :see_other
  end
end