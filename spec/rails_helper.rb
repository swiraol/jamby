ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'capybara/rspec'
require 'vcr'
require 'zonebie/rspec'
require 'pusher-fake/support/rspec'
require 'vcr_helper'

require './spec/support/pages/page_object'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

if ENV['SELENIUM']
  Capybara.default_driver = :selenium
else
  Capybara.javascript_driver = :webkit
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
  config.include ShowMeTheCookies, :type => :feature
  config.include SigninHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  config.before(:suite, type: :js) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
