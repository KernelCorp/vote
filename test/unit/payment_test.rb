require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test 'approve!' do
    payment = payments(:not_approved)
    payment.approve!
    assert payment.approved?
  end

  test 'approve! for user with parent' do
    user = users(:new)
    parent_old_balance = user.parent.billinfo
    payment = user.payments.create! amount: 100
    payment.approve!
    assert payment.approved?, "payment isn't approved"
    assert payment.user.parent.billinfo == (parent_old_balance + 10)
    assert payment.user.paid
  end

  test 'scope approved' do
    assert !Payment.approved.all.blank?
  end
end
