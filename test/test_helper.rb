ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # should enable methods such as pluralize
  include ActionView::Helpers::TextHelper
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup do
    I18n.locale = :en
  end

  def login_as(user)
    post login_path, params: { user: { username: user.username,
                                       password: "pass"} }
  end

  def logout
    session[:user_id] = nil
  end

  def logged_in?
    !!session[:user_id]
  end
end

module ActionDispatch::Integration
  class Session
    def default_url_options
      { locale: I18n.locale }
    end
  end
end