require 'rails_helper'

RSpec.describe Post, type: :model do
  fixtures :users, :posts
  let(:user) { users(:michael) }
  let(:post) { posts(:one) }

  it 'is valid when arguments are valid' do
    expect(post).to be_valid
  end

  it 'is invalid when title is empty' do
    post.title = '  '
    expect(post).not_to be_valid
  end

  it 'is invalid when both link and content are empty' do
    post.link = post.content = '  '
    expect(post).not_to be_valid
  end
end
