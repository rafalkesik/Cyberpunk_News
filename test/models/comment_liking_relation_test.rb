require "test_helper"

class CommentLikingRelationTest < ActiveSupport::TestCase
  def setup
    @relation = CommentLikingRelation.new(liking_user_id:   1,
                                          liked_comment_id: 1)
  end

  test "should be valid" do
    assert @relation.valid?
  end

  test "liked_comment should be present" do
    @relation.liked_comment = nil
    refute @relation.valid?
  end

  test "liked_user should be present" do
    @relation.liking_user = nil
    refute @relation.valid?
  end
end
