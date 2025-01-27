require 'rails_helper'

RSpec.describe CommentLikingRelation, type: :model do
  fixtures :comment_liking_relations
  let(:relation) { comment_liking_relations(:one_likes_two) }

  it 'is valid with valid arguments' do
    expect(relation).to be_valid
  end

  it 'is invalid with no liked_comment' do
    relation.liked_comment = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid with no liked_user' do
    relation.liking_user = nil
    expect(relation).not_to be_valid
  end
end
