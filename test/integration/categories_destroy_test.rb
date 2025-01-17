require 'test_helper'

class CategoriesDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @category = categories(:two)
    @default_category = categories(:one)
    @posts_count = @category.posts.count
    admin = users(:admin)
    login_as(admin)
  end

  test 'should destroy category as admin' do
    assert_difference '@default_category.posts.count', @posts_count do
      assert_difference 'Category.count', -1 do
        delete category_path(@category.slug),
               as: :turbo_stream
      end
    end

    assert_select 'div.alert-success', 'Category deleted.'
  end
end
