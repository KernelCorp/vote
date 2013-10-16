require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  test "[]" do
    phone = phones :one
    (1..10).each do |i|
      assert phone[i] == phone.number[i]
    end
  end
end
