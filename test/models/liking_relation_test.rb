require 'test_helper'

class LikingRelationTest < ActiveSupport::TestCase
  
  def setup
    @relation = LikingRelation.new(liking_user_id: 1,
                                   liked_post_id:  2)
  end

  test 'should be valid' do
    assert @relation.valid?
  end

  test 'relation with no liking_user should not be valid' do
    @relation.liking_user_id = nil
    assert_not @relation.valid?
  end

  test 'relation with no liked_post should not be valid' do
    @relation.liked_post_id = nil
    assert_not @relation.valid?
  end

  test 'relation with non-existent liking_user should not be valid' do
    @relation.liking_user_id = 987654321
    assert_not @relation.valid?
  end
  test 'relation with non-existent liked_post should not be valid' do
    @relation.liked_post_id = 987654321
    assert_not @relation.valid?
  end
end
