require 'test_helper'

class VotingTest < ActiveSupport::TestCase

  test 'complete if necessary for voting with way to complete like users count' do
    voting = votings(:current)
    count_participants = (voting.claims.group_by { |claim| claim.participant.id}).count
    voting.max_users_count = count_participants
    assert voting.complete_if_necessary!
    assert voting.status == :prizes
  end

  test 'complete if necessary for voting with way to complete like sum' do
    voting = votings(:current)
    voting.budget = 20
    voting.way_to_complete = 'sum'
    assert voting.complete_if_necessary!
    assert voting.status == :prizes
  end

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
    assert phones.first == middlebrow.phones.first
    assert phones.second == middlebrow.phones.second
  end

  test 'returning lengths to upper places for phone' do
    voting = votings(:current)
    phone = phones(:middlebrow_first)
    lengths = voting.positions_and_lengths_to_upper_places_for_phone phone
    should_be_lengths = [277, 234, 192, 151, 112, 78, 55, 33, 12]
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

  test 'cannot activate voting with not confirmed organization' do
    voting = votings :try_to_activate_me
    voting.status = :active
    assert voting.invalid?
  end

  test 'confirm organization and activate voting' do
    voting = votings :try_to_activate_me
    org = voting.organization
    org.is_confirmed = 1
    org.save!
    voting.status = :active
    assert voting.valid?
  end

end
