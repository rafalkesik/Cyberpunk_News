require 'test_helper'

class CategoriesNotLoggedIn < ActionDispatch::IntegrationTest
  def setup
    @category = categories(:one)
  end
end

class CategoriesNotLoggedInTest < CategoriesNotLoggedIn
  test 'should redirect new if not logged in' do
    get new_category_path, as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', 'Log in to submit or edit categories.'
  end

  test 'should redirect create if not logged in' do
    post categories_path, as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', 'Log in to submit or edit categories.'
  end

  test 'should redirect destroy if not logged in' do
    delete category_path(@category), as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', 'Log in to submit or edit categories.'
  end
end

class CategoriesLoggedInTest < CategoriesNotLoggedIn
  def setup
    super
    user = users(:michael)
    login_as(user)
  end

  test 'should redirect destroy if not admin' do
    delete category_path(@category), as: :turbo_stream
    assert_redirected_to root_url
    assert_response :see_other
  end
end
