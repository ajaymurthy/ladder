ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
# require "minitest/pride"

FactoryGirl.find_definitions

class MiniTest::Rails::ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods

  def login_service
    service = create(:service)
    OmniAuth.config.add_mock(:developer, "uid" => service.uid, "info" => {"name" => service.name, "email" => service.email})
    visit session_path
    click_link "Developer"
    must_have_content "Signed in successfully via Developer"
    service
  end
end

# Do you want all existing Rails tests to use MiniTest::Rails?
# Comment out the following and either:
# A) Change the require on the existing tests to `require "minitest_helper"`
# B) Require this file's code in test_helper.rb

# MiniTest::Rails.override_testunit!
