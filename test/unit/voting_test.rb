require 'test_helper'

class VotingTest < ActiveSupport::TestCase

  test 'counting the number of matches for phone' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number
    count = voting.matches_count phone
    assert count == 10
  end

  test 'rating for phone number' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number
    rating = voting.get_rating_for_phone phone
    assert rating == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  test 'ratings for phone numbers' do
    voting = votings(:current)
    phones = [ phones(:middlebrow_first) ]
    phones.push Phone.new(number: voting.phone.lead_phone_number)
    ratings = voting.get_ratings_for_phones phones
    assert ratings.first == [8, 9, 7, 3, 5, 1, 2, 4, 6, 10]
    assert ratings.second == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  test 'returning sorted phones for participant' do
    voting = votings(:current)
    middlebrow = users(:middlebrow)
    middlebrow.phones.create! number: voting.phone.lead_phone_number
    middlebrow.claims.create! voting: voting, phone: middlebrow.phones.second
    phones = voting.get_sorted_phone_numbers_for_participant middlebrow
    assert phones.first == middlebrow.phones.second
    assert phones.second == middlebrow.phones.first
  end
end
