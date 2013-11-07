require 'test_helper'

class VotingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'counting the number of matches for phone' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number
    count = voting.matches_count phone.number
    assert count == 10
  end

  test 'rating for phone number' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number
    rating = voting.get_rating_for_phone
    assert rating == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  test 'rating for phone numbers' do
    voting = votings(:current)
    phones = []
    phones.push Phone.new(number: voting.phone.lead_phone_number)
    phones.push Phone.new(number: '1234567890')
  end
end
