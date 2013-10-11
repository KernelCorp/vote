require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  test 'PhoneNumber always have 10 associations with Position' do
    p = PhoneNumber.new
    count = 0
    p.each_with_index do |po, i|
      if (!po.nil? and po.class == Position)
        count += 1
      end
    end
    assert count == 10
  end

  test 'PhoneNumber has ability to get Position association by index' do
    p = phone_numbers(:only_phone)
    a = (0..9).to_a
    ass = p[a.shuffle.first]
    assert (!ass.nil? and ass.class == Position)
  end

  test 'PhoneNumber can give lead phone number in voting' do
    p = phone_numbers(:only_phone)
    assert [7, 7, 7, 7, 7, 7, 7, 7, 7, 7] == p.lead_phone_number
  end
end
