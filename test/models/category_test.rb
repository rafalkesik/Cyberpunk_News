require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(title: 'Valid title',
                             slug: 'valid_slug',
                             description: 'Valid description.')
  end

  test 'should be valid' do
    assert @category.valid?
  end

  test 'title should be nonempty' do
    @category.title = ' '
    assert_not @category.valid?
  end

  test 'title should be unique' do
    @category.title = 'Inne'
    assert_not @category.valid?
  end

  test 'description should be nonempty' do
    @category.description = ' '
    assert_not @category.valid?
  end

  test 'description should be unique' do
    @category.description = "Default category for posts that don't"
    assert_not @category.valid?
  end

  test 'slug should be nonempty' do
    @category.slug = ' '
    assert_not @category.valid?
  end

  test 'slug should be unique' do
    @category.slug = 'inne'
    assert_not @category.valid?
  end

  test 'slug should be url-friendly' do
    @category.slug = 'Other pots//'
    assert_not @category.valid?
  end
end
