require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  test '[]' do
    phone = phones :middlebrow_first
    (0..9).each do |i|
      assert phone[i] == phone.number[i].to_i
    end
  end
end
