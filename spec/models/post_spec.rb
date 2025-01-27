require 'rails_helper'

RSpec.describe Post, type: :model do
  fixtures :users, :posts
  let(:user) { users(:michael) }
  let(:post) { posts(:one) }

  it 'is valid with valid arguments' do
    expect(post).to be_valid
  end

  it 'is invalid with empty title' do
    post.title = '  '
    expect(post).not_to be_valid
  end

  it 'is invalid with both link and content being empty' do
    post.link = post.content = '  '
    expect(post).not_to be_valid
  end
end
