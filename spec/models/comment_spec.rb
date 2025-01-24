require 'rails_helper'

RSpec.describe Comment, type: :model do
  fixtures :comments
  let(:comment) { comments(:parent_of_three_and_four) }

  it 'is valid with valid arguments' do
    expect(comment).to be_valid
  end

  it 'is invalid with empty content' do
    comment.content = ''
    expect(comment).not_to be_valid
  end
end
