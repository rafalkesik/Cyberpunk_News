require 'rails_helper'

RSpec.describe Category, type: :model do
  fixtures :categories
  let(:category) { categories(:one) }

  it 'is valid when arguments are valid' do
    expect(category).to be_valid
  end

  it 'is invalid when title is empty' do
    category.title = ' '
    expect(category).not_to be_valid
  end

  it 'is invalid when title is not unique' do
    category.title = 'Politics'
    expect(category).not_to be_valid
  end

  it 'is invalid when description is empty' do
    category.description = ' '
    expect(category).not_to be_valid
  end

  it 'is invalid when description is not unique' do
    category.description = 'Everything about politics in Poland an abroad.'
    expect(category).not_to be_valid
  end

  it 'is invalid when slug is empty' do
    category.slug = ' '
    expect(category).not_to be_valid
  end

  it 'is invalid when slug is not unique' do
    category.slug = 'politics'
    expect(category).not_to be_valid
  end

  it 'is invalid when slug is not URL-friendly' do
    category.slug = 'poli tics/'
    expect(category).not_to be_valid
  end
end
