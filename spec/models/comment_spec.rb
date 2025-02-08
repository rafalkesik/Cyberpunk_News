require 'rails_helper'

RSpec.describe Comment, type: :model do
  fixtures :comments
  let(:comment) { comments(:parent_of_three_and_four) }

  it 'is valid when arguments are valid' do
    expect(comment).to be_valid
  end

  it 'is invalid when content is empty' do
    comment.content = ''
    expect(comment).not_to be_valid
  end
end
