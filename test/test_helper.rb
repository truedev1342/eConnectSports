ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests.
    fixtures :all
  end
end

# Nearly every controller sits behind `authenticate_user!`, so the Devise test
# helpers need to be available to the controller and integration tests.
class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
