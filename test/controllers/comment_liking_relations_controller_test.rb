require "test_helper"

class CommentLikingRelationsControllerTest < ActionDispatch::IntegrationTest

  test "should flash warning on create if not logged in" do
    assert_difference 'CommentLikingRelation.count', 0 do
      post comment_liking_relations_path,
           as: :turbo_stream,
           params: { liking_user_id: 1,
                     liked_comment_id: 1 }
    end
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end
end
