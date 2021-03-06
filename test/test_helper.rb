# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'simplecov'
require 'coveralls'

SimpleCov.start('rails') do
  if ENV['CI']
    formatter Coveralls::SimpleCov::Formatter
  end
end

Rails.application.eager_load!

class ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include AuthHelper
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
