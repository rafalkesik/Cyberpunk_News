require 'rails_helper'

RSpec.describe Category, type: :model do
  fixtures :categories
  let(:category) { categories(:one) }

  it 'is valid with valid arguments' do
    expect(category).to be_valid
  end

  it 'is invalid with empty title' do
    category.title = ' '
    expect(category).not_to be_valid
  end

  it 'is invalid with non-unique title' do
    category.title = 'Politics'
    expect(category).not_to be_valid
  end

  it 'is invalid with empty description' do
    category.description = ' '
    expect(category).not_to be_valid
  end

  it 'is invalid with non-unique title' do
    category.description = 'Everything about politics in Poland an abroad.'
    expect(category).not_to be_valid
  end

  it 'is invalid with empty slug' do
    category.slug = ' '
    expect(category).not_to be_valid
  end

  it 'is invalid with non-unique slug' do
    category.slug = 'politics'
    expect(category).not_to be_valid
  end

  it 'is invalid with non-url-friendly slug' do
    category.slug = 'poli tics/'
    expect(category).not_to be_valid
  end
end
