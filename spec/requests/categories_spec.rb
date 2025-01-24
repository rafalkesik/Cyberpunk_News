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
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert-warning', 'Log in to submit or edit categories.'
      end
    end
  end

  describe 'SHOW /categories/:slug' do
    fixtures :categories
    let(:category) { categories(:two) }

    it 'renders layout' do
      get category_path(category.slug), as: :turbo_stream

      expect(response).to render_template('categories/show')
      assert_select 'h3', "-#{category.title}-"
      assert_select 'p', category.description
      assert_select 'form[action=?]', new_post_path do
        assert_select 'input[name="category_id"][value=?]', category.id
      end
    end
  end

  describe 'POST /categories' do
    fixtures :users
    let(:user) { users(:michael) }

    context 'when not logged in' do
      it "doesn't create a post and redirects to login url" do
        expect { post categories_path, as: :turbo_stream }.to change(Category, :count).by(0)
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert-warning', 'Log in to submit or edit categories.'
      end
    end

    context 'when logged in' do
      before do
        login_as(user)
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

        assert_select 'div.alert-success', 'Category created!'
        assert_select 'a', 'New Category'
      end

      it 'does not create category with invalid data' do
        expect do
          post categories_path,
               as: :turbo_stream,
               params: { category: { title: ' ',
                                     slug: 'Test Slug',
                                     description: '' } }
        end.to change(Category, :count).by(0)

        assert_select 'div.error-explanation' do
          assert_select 'div.alert-danger',
                        'The form contains errors:'
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
        login_as(non_admin)
      end

      it "doesn't create category and redirects to root" do
        expect do
          delete category_path(category), as: :turbo_stream
        end.to change(Category, :count).by(0)
        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
      end
    end

    context 'when an admin' do
      before do
        login_as(admin)
      end

      it 'destroys a category' do
        expect do
          expect do
            delete category_path(category.slug),
                   as: :turbo_stream
          end.to change(Category, :count).by(-1)
        end.to change { default_category.posts.count }.by(posts_count)

        assert_select 'div.alert-success', 'Category deleted.'
      end
    end
  end
end
