require 'rails_helper'

RSpec.describe CommentLikingRelation, type: :model do
  fixtures :comment_liking_relations
  let(:relation) { comment_liking_relations(:one_likes_two) }

  it 'is valid when arguments are valid' do
    expect(relation).to be_valid
  end

  it 'is invalid when liked_comment_id is empty' do
    relation.liked_comment_id = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid when liked_comment_id does not exist' do
    relation.liked_comment_id = 987_654_321
    expect(relation).not_to be_valid
  end

  it 'is invalid when liking_user_id is empty' do
    relation.liking_user_id = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid when liking_user_id does not exist' do
    relation.liking_user_id = 987_653_321
    expect(relation).not_to be_valid
  end
end
