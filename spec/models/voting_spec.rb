require 'spec_helper'

describe Voting do

  it 'complete if necessary for voting with way to complete like users count' do
    voting = votings(:current)
    count_participants = (voting.claims.group_by { |claim| claim.participant.id}).count
    voting.max_users_count = count_participants
    voting.complete_if_necessary!.should_not == nil
    voting.status.should == :prizes
  end

  it 'complete if necessary for voting with way to complete like sum' do
    voting = votings(:current)
    voting.budget = 20
    voting.way_to_complete = 'sum'
    voting.complete_if_necessary!.should_not == nil
    voting.status.should == :prizes
  end

  it 'counting the number of matches for phone' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number
    count = voting.matches_count phone
    count.should == 10
    phone = '1234567890'
    count = voting.matches_count phone
    count.should == 1
  end

  it 'rating for phone number' do
    voting = votings(:current)
    phone = Phone.new number: voting.phone.lead_phone_number
    rating = voting.rating_for_phone phone
    rating.should == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  it 'ratings for phone numbers' do
    voting = votings(:current)
    phones = [ phones(:middlebrow_first) ]
    phones.push Phone.new(number: voting.phone.lead_phone_number)
    ratings = voting.ratings_for_phones phones
    ratings.first.should == [8, 9, 7, 3, 5, 1, 2, 4, 6, 10]
    ratings.second.should == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  it 'returning sorted phones for participant' do
    voting = votings(:current)
    middlebrow = users(:middlebrow)
    middlebrow.phones.create! number: voting.phone.lead_phone_number
    middlebrow.claims.create! voting: voting, phone: middlebrow.phones.second
    phones = voting.sorted_phone_numbers_for_participant middlebrow
    phones.first.should == middlebrow.phones.first
    phones.second.should == middlebrow.phones.second
  end

  it 'returning lengths to upper places for phone' do
    voting = votings(:current)
    phone = phones(:middlebrow_first)
    lengths = voting.positions_and_lengths_to_upper_places_for_phone phone
    should_be_lengths = [277, 234, 192, 151, 112, 78, 55, 33, 12]
    all_position = [6, 3, 7, 4, 8, 2, 0, 1, 9]
    should_be = []
    should_be_lengths.each_with_index { |l, i| should_be << { i: all_position.slice(0..(8 - i)), l: l } }
    lengths.should == should_be
  end

  it 'super test for returning lengths' do
    voting = votings :get_drunk!
    phone = '0000000011'
    actual = voting.positions_and_lengths_to_upper_places_for_phone phone
    true.should_not == nil

  end

  it 'determine place for phone' do
    voting = voting = votings(:current)
    phone = phones(:middlebrow_first)
    2.should == voting.determine_place(phone)
    0.should == voting.determine_place('0001112233')
  end

  it 'cannot activate voting with not confirmed organization' do
    voting = votings :try_to_activate_me
    voting.status = :active
    voting.invalid?.should_not == nil
  end

  it 'confirm organization and activate voting' do
    voting = votings :try_to_activate_me
    org = voting.organization
    org.is_confirmed = 1
    org.save!
    voting.status = :active
    voting.valid?.should_not == nil
  end

end
