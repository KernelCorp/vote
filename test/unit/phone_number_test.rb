require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

  test 'PhoneNumber has ability to get Position association by index' do
    p = phone_numbers(:only_phone)
    a = p[rand(10)]
    assert (!a.nil? and a.class == Position)
  end

  test 'PhoneNumber can give lead phone number in voting' do
    p = phone_numbers(:only_phone)
    assert [6, 6, 6, 6, 6, 6, 6, 6, 6, 6] == p.lead_phone_number
  end

  test 'returning votes count for phone number' do
    p = phone_numbers(:only_phone)
    count = p.votes_count_for_phone_number Phone.new(number: '1234567890')
    assert count == 162
  end
end
