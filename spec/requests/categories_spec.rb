require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  describe 'GET /categories' do
    it 'works! (now write some real specs)' do
      get categories_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /categories' do
    fixtures :users
    let(:user) { users(:michael) }

    before do
      # login_as(user)
    end

    it 'creates a valid category and redirects to categories path' do
      expect do
        post categories_path,
             as: :turbo_stream,
             params: { category: { title: 'New Category',
                                   slug: 'new_category',
                                   description: 'Lorem impsum' } }
      end.to change(Category, :count).by(1)

      expect(response).to redirect_to(categories_path)
      expect(response).to have_http_status(:see_other)

      follow_redirect!
      expect(response.body).to have_css('div.alert-success',
                                        text: 'Category created!')
      expect(response.body).to have_css('a', text: 'New Category')
    end


  end
end
