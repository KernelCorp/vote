ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

def setup_for_phone_number
  # Dirty trick
  PhoneNumber.send :define_method, :populate_with_positions, proc { true }
  Position.send :define_method, :fullup_votes, proc { true }
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  setup_for_phone_number
end
