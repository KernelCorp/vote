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
    rating = voting.rating_for_phone phone
    assert rating == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  test 'ratings for phone numbers' do
    voting = votings(:current)
    phones = [ phones(:middlebrow_first) ]
    phones.push Phone.new(number: voting.phone.lead_phone_number)
    ratings = voting.ratings_for_phones phones
    assert ratings.first == [8, 9, 7, 3, 5, 1, 2, 4, 6, 10]
    assert ratings.second == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  test 'returning sorted phones for participant' do
    voting = votings(:current)
    middlebrow = users(:middlebrow)
    middlebrow.phones.create! number: voting.phone.lead_phone_number
    middlebrow.claims.create! voting: voting, phone: middlebrow.phones.second
    phones = voting.sorted_phone_numbers_for_participant middlebrow
    assert phones.first == middlebrow.phones.second
    assert phones.second == middlebrow.phones.first
  end

  test 'returning lengths to upper places for phone' do
    voting = votings(:current)
    phone = phones(:middlebrow_first)
    lengths = voting.positions_and_lengths_to_upper_places_for_phone phone
    should_be_lengths = [268, 226, 185, 145, 107, 74, 52, 31, 11]
    all_position = [6, 3, 7, 4, 8, 2, 0, 1, 9]
    should_be = []
    should_be_lengths.each_with_index { |l, i| should_be << { i: all_position.slice(0..(8 - i)), l: l } }
    assert lengths == should_be
  end

  test 'determine place for phone' do
    voting = voting = votings(:current)
    phone = phones(:middlebrow_first)
    assert_equal voting.determine_place(phone), 2
    assert_equal voting.determine_place('0001112233'), 0
  end

end
