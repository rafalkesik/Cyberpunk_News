require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  describe 'GET /categories' do
    it 'renders all categories' do
      get categories_path, as: :turbo_stream

      expect(response).to have_http_status(200)
      assert_select 'form[action=?]', new_category_path
      Category.all.each do |category|
        assert_select 'a[href=?]',
                      category_path(category.slug),
                      category.title
      end
    end
  end

  describe 'NEW /categories' do
    context 'when not logged in' do
      it 'redirects to login url' do
        get new_category_path, as: :turbo_stream

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(302)
        follow_redirect!
        expect(response.body).to include(
          (I18n.t 'devise.failure.unauthenticated')
        )
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        sign_in user
      end

      it 'renders new category form' do
        get new_category_path, as: :turbo_stream

        expect(response).to have_http_status(200)
        expect(response).to render_template('categories/new')
      end
    end
  end

  describe 'SHOW /categories/:slug' do
    fixtures :categories
    let(:category) { categories(:two) }

    it 'renders all posts under this category' do
      get category_path(category.slug), as: :turbo_stream

      expect(response).to render_template('categories/show')
      category.posts.each do |post|
        assert_select 'a', post.title
      end
    end
  end

  describe 'POST /categories' do
    fixtures :users
    let(:user) { users(:michael) }

    def perform_post_request(categories_params)
      post categories_path, as: :turbo_stream, params: { category: categories_params }
    end

    context 'when not logged in' do
      it "doesn't create a category" do
        expect { perform_post_request('') }.to change(Category, :count).by(0)
      end

      it 'redirects to login_url' do
        perform_post_request('')

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(302)
        follow_redirect!
        expect(response.body).to include(
          (I18n.t 'devise.failure.unauthenticated')
        )
      end
    end

    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when data is invalid' do
        let(:invalid_category_params) do
          { title: ' ',
            slug: 'Test Slug',
            description: '' }
        end

        it 'does not create category' do
          expect do
            perform_post_request(invalid_category_params)
          end.to change(Category, :count).by(0)

          expect(response.body).to include(
            (I18n.t 'error.count')
          )
        end
      end

      context 'when data is valid' do
        let(:valid_category_params) do
          { title: 'New Category',
            slug: 'new_category',
            description: 'Lorem impsum' }
        end

        it 'creates the category' do
          expect do
            perform_post_request(valid_category_params)
          end.to change(Category, :count).by(1)
        end

        it 'redirects to categories path' do
          perform_post_request(valid_category_params)

          expect(response).to redirect_to(categories_path)
          expect(response).to have_http_status(303)
          follow_redirect!
          expect(response.body).to include(
            (I18n.t 'flash.category_created')
          )
          assert_select 'a', valid_category_params[:title]
        end
      end
    end
  end

  describe 'DELETE /categories/:slug' do
    fixtures :categories, :users
    let(:category) { categories(:two) }
    let(:default_category) { categories(:one) }
    let(:posts_count) { category.posts.count }
    let(:admin) { users(:admin) }
    let(:non_admin) { users(:michael) }

    context 'when not an admin' do
      before do
        sign_in non_admin
      end

      it "doesn't delete category" do
        expect do
          delete category_path(category), as: :turbo_stream
        end.to change(Category, :count).by(0)
      end

      it 'redirects to root' do
        delete category_path(category), as: :turbo_stream

        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
      end
    end

    context 'when an admin' do
      before do
        sign_in admin
      end

      it 'deletes the category' do
        expect do
          delete category_path(category.slug), as: :turbo_stream
        end.to change(Category, :count).by(-1)

        expect(response.body).to include(
          (I18n.t 'flash.category_deleted')
        )
      end

      it "deletes category's posts" do
        expect do
          delete category_path(category.slug), as: :turbo_stream
        end.to change { default_category.posts.count }.by(posts_count)
      end
    end
  end
end
