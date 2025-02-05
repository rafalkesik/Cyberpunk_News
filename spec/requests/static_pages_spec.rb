require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  RSpec.shared_examples 'check h1' do |heading|
    it 'renders the right h1' do
      assert_select 'h1', heading
    end
  end

  describe 'GET /' do
    context 'when not logged in' do
      before { get root_url, as: :turbo_stream }

      include_examples 'check h1', 'All Cyber News'

      it 'renders full page layout' do
        assert_select 'a[href=?]', '/en', count: 3
        assert_select 'a[href=?]', '/pl', count: 1
        assert_select 'a[href=?]', login_path
        assert_select 'header'
        assert_select 'div.content-container'
        assert_select 'footer'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        login_as(user)
        get root_url, as: :turbo_stream
      end

      it 'also renders profile link' do
        assert_select 'a[href=?]', user_path(user)
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
