require 'test_helper'

class LikingRelationsNotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @relation = liking_relations(:one_likes_two)
  end
end

class LikingRelationsNotLoggedInTest < LikingRelationsNotLoggedIn

  test 'should flash warning on create if not logged in' do
    post liking_relations_path, as: :turbo_stream
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end

  test 'should flash warning on destroy if not logged in' do
    delete liking_relations_path, as: :turbo_stream
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end
end