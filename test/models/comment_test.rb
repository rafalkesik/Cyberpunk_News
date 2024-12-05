require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = Comment.new(post_id: 1,
                           user_id: 1,
                           content: "Valid content",
                           points: 0)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "content should be non-empty" do
    @comment.content = ""
    refute @comment.valid?
  end
end