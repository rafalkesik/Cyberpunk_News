require "test_helper"

class CategoryShowTest < ActionDispatch::IntegrationTest
  def setup
    @category = categories(:two)
    get category_path(@category.slug), as: :turbo_stream
  end

  test 'should render layout' do
    assert_template 'categories/show'
    assert_select 'h3', "-#{@category.title}-"
    assert_select 'p', @category.description
    assert_select 'form[action=?]', new_post_path do
      assert_select 'input[name="category_id"][value=?]', @category.id
    end

    @category.posts.each do |post|
      assert_select 'a[href=?]', post_path(post),
                                 post.title
    end
  end
end
