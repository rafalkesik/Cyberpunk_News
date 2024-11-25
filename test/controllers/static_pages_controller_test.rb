require "test_helper"

class StaticPages < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
end

class StaticPagesTest < StaticPages
  test "should render full layout" do
    get root_url
    assert_select 'a[href=?]', '/', count: 2
    assert_select 'a[href=?]', '/login'
    assert_select 'header'
    assert_select 'div.content-container'
    assert_select 'footer'
  end

  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get guidlines" do
    get guidelines_url
    assert_response :success
    assert_select 'h1', "Guidelines"
  end

  test "should get faq" do
    get faq_url
    assert_response :success
    assert_select 'h1', "FAQ"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select 'h1', "Contact"
  end
end

class StaticPagesLoggedInTest < StaticPages

  def setup
    super
    login_as(@user)
  end

  test "should render full layout as logged in user" do
    get root_url
    assert_select 'a[href=?]', user_path(@user)
  end
end