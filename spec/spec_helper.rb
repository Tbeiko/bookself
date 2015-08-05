ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => "facebook",
    :uid      => "12345",
    :info     => {
      :first_name => "Tim",
      :last_name  => "Bagel",
      :email      => "tim@bagel.com",
      :image      => "http://graph.facebook.com/10153053628432523/picture"
    },
    :credentials => {
      :token       => "123456",
      :expires_at  => 1352419328
    },
  })

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false


  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.infer_spec_type_from_file_location!
  config.order = :random  
end
