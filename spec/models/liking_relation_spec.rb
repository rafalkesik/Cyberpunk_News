require 'rails_helper'

RSpec.describe LikingRelation, type: :model do
  let(:relation) { LikingRelation.new(liking_user_id: 1, liked_post_id: 2) }

  it 'is valid when arguments are valid' do
    expect(relation).to be_valid
  end

  it 'is invalid when liking_user_id is empty' do
    relation.liking_user_id = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid when liking_user_id does not exist' do
    relation.liking_user_id = 987_653_321
    expect(relation).not_to be_valid
  end

  it 'is invalid when liked_post_id is empty' do
    relation.liked_post_id = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid when liked_post_id does not exist' do
    relation.liked_post_id = 987_654_321
    expect(relation).not_to be_valid
  end
end
