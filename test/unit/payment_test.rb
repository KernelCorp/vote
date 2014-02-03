require 'test_helper'

class PaymentTest < ActiveSupport::TestCase

  setup do
    back_to_1985 # To present I mean
  end

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
    time_travel_to '26/11/2013'.to_datetime
    payment = payments :with_promo
    promo = Promo.find_by_code payment.promo
    user_billinfo_old = payment.user.billinfo
    payment.approve!

    assert payment.approved?
    assert_equal user_billinfo_old, (payment.user.billinfo - payment.amount - promo.amount)
  end

  test 'approve with promo twice' do
    time_travel_to '26/11/2013'.to_datetime
    payment = payments :with_promo
    promo = Promo.find_by_code payment.promo
    payment.approve!
    user_billinfo_old = payment.user.billinfo
    second_payment = payment.dup
    second_payment.save
    second_payment.approve!

    assert payment.approved? && second_payment.approved?
    assert_equal (user_billinfo_old), (second_payment.user.billinfo - second_payment.amount)
  end

end
