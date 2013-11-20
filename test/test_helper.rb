ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

def setup_for_phone_number
  # Dirty trick
  Voting.send :define_method, :build_some_phone, proc { true }
  Voting.send :define_method, :save_for_future, proc { true }
  PhoneNumber.send :define_method, :populate_with_positions, proc { true }
  PhoneNumber.send :define_method, :save_for_future, proc { true }
  Position.send :define_method, :fullup_votes, proc { true }
  Position.send :define_method, :save_for_future, proc { true }
end

class ActionController::TestCase
  include Devise::TestHelpers
  include Delorean
  fixtures :all
end


class ActiveSupport::TestCase
  include Delorean
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  setup_for_phone_number
end
