require 'test_helper'

class VotingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'counting the number of matches for phone' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number.join
    count = voting.matches_count phone.number
    assert count == 10
  end
end
