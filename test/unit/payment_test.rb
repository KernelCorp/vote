require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test 'approve!' do
    payment = payments(:not_approved)
    user_billinfo_old = payment.user.billinfo
    payment.approve!
    assert payment.approved?
    assert_equal user_billinfo_old, (payment.user.billinfo - payment.amount)
  end

  test 'approve! for user with parent' do
    user = users(:new)
    parent_old_balance = user.parent.billinfo
    payment = user.payments.create! amount: 90, currency: 'WMRM', with_promo: 0
    payment.approve!
    delta = payment.amount * 0.1
    assert payment.approved?, 'payment isn\'t approved'
    assert payment.user.parent.billinfo == (parent_old_balance + delta)
    assert payment.user.paid
  end

  test 'scope approved' do
    assert !Payment.approved.all.blank?
  end

  test 'approve with promo' do
    payment = payments :with_promo
    promo = Promo.find_by_code payment.promo
    user_billinfo_old = payment.user.billinfo
    payment.approve!
    assert payment.approved?
    assert_equal user_billinfo_old, (payment.user.billinfo - payment.amount - promo.amount)
  end

end
