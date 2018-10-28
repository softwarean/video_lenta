ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start('rails') if ENV["COVERAGE"]

if ENV["CI_REPORTER"]
  require 'minitest/reporters'
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::JUnitReporter.new]
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Concerns::Auth
end
