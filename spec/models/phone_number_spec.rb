require 'spec_helper'

describe PhoneNumber do

  it 'PhoneNumber has ability to get Position association by index' do
    p = phone_numbers(:only_phone)
    a = p[rand(10)]
    (!a.nil? and a.class == Position).should_not == nil
  end

  it 'PhoneNumber can give lead phone number in voting' do
    p = phone_numbers(:only_phone)
    p.lead_phone_number.should eq([6, 6, 6, 6, 6, 6, 6, 6, 6, 6])
  end

  it 'returning votes count for phone number' do
    p = phone_numbers(:only_phone)
    count = p.votes_count_for_phone_number Phone.new(number: '1234567890')
    count.should == 162
  end
end
