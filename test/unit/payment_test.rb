require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test 'approve!' do
    payment = payments(:not_approved)
    payment.approve!
    assert payment.approved?
  end

  test 'scope approved' do
    assert !Payment.approved.all.blank?
  end
end
