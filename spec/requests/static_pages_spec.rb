require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  RSpec.shared_examples 'check h1' do |heading|
    it "renders page with title: #{heading}" do
      expect(response).to have_http_status(200)
      assert_select 'h1', heading
    end
  end

  describe 'GET /' do
    before do
      get root_url, as: :turbo_stream
    end

    include_examples 'check h1', (I18n.t 'all_posts', locale: :en)

    context 'when not logged in' do
      it 'renders header with login link' do
        assert_select 'header' do
          assert_select 'a[href=?]', login_path
        end
        assert_select 'div.content-container'
        assert_select 'footer'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        sign_in user
        get root_url, as: :turbo_stream
      end

      it 'renders header with profile link' do
        assert_select 'header' do
          assert_select 'a[href=?]', user_path(user)
        end
      end
    end
  end

  describe 'GET /guidelines' do
    before { get guidelines_url, as: :turbo_stream }
    include_examples 'check h1', 'Guidelines'
  end

  describe 'GET /faq' do
    before { get faq_url, as: :turbo_stream }
    include_examples 'check h1', 'FAQ'
  end

  describe 'GET /contact' do
    before { get contact_url, as: :turbo_stream }
    include_examples 'check h1', 'Contact'
  end
end
