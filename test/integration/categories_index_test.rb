require 'test_helper'

class CategoriesIndexTest < ActionDispatch::IntegrationTest
  test 'should render all categories' do
    get categories_path, as: :turbo_stream

    assert_select 'form[action=?]', new_category_path
    Category.all.each do |category|
      assert_select 'a[href=?]', category_path(category.slug), category.title
    end
  end
end
