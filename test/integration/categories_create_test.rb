require 'test_helper'

class CategoriesCreateTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    login_as(user)
  end

  test 'should create a valid category' do
    assert_difference 'Category.count', 1 do
      post categories_path, as: :turbo_stream,
                            params: { category: { title: 'New Category',
                                                  slug: 'new_category',
                                                  description: 'Lorem impsum' } }
    end

    assert_redirected_to categories_path
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', 'Category created!'
    assert_select 'a', 'New Category'
  end

  test 'should not create category with invalid data' do
    assert_difference 'Category.count', 0 do
      post categories_path, as: :turbo_stream,
                            params: { category: { title: ' ',
                                                  slug: 'Test Slug',
                                                  description: '' } }
    end

    assert_select 'div.error-explanation' do
      assert_select 'div.alert-danger',
                    'The form contains errors:'
    end
  end
end
