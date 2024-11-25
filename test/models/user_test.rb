require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username:              "Example User",
                     password:              "GoodPassword1!",
                     password_confirmation: "GoodPassword1!")
  end

  test "should be invalid" do
    assert @user.valid?
  end

  test "username should be non-empty" do
    @user.username = "    "
    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.username = "michael"
    assert_not @user.valid?
  end

  test "password should be non-empty" do
    @user.password = @user.password_confirmation = "   "
    assert_not @user.valid?
  end
  
  test "passwords should match" do
    @user.password_confirmation = "DifferentPassword"
    assert_not @user.valid?
  end
end
