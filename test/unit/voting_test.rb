require 'test_helper'

class VotingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'counting the number of matches for phone' do
    voting = votings(:current)
    phone = Phone.new number: '79112223344'
    count = voting.matches_count phone.number

  end
end
