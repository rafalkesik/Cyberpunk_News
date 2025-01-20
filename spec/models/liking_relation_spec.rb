require 'rails_helper'

RSpec.describe LikingRelation, type: :model do
  let(:relation) { LikingRelation.new(liking_user_id: 1, liked_post_id: 2) }

  it 'is valid with valid arguments' do
    expect(relation).to be_valid
  end

  it 'is invalid with no liking_user' do
    relation.liking_user_id = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid with no liked_post' do
    relation.liked_post_id = nil
    expect(relation).not_to be_valid
  end

  it 'is invalid with non-existent liking_user' do
    relation.liking_user_id = 987_653_321
    expect(relation).not_to be_valid
  end

  it 'is invalid with non-existent liked_post' do
    relation.liked_post_id = 987_654_321
    expect(relation).not_to be_valid
  end
end
