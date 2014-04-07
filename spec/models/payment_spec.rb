require 'spec_helper'

describe Payment do

  setup do
    back_to_1985 # To present I mean
  end

  it 'approve!' do
    payment = payments(:not_approved)
    user_billinfo_old = payment.user.billinfo
    payment.approve!

    payment.approved?.should_not be_nil
    (payment.user.billinfo - payment.amount).should eq(user_billinfo_old)
  end

  it 'approve! for user with parent' do
    user = users(:new)
    parent_old_balance = user.parent.billinfo
    payment = user.payments.create! amount: 90, currency: 'WMRM', with_promo: 0
    payment.approve!
    delta = payment.amount * 0.1

    payment.approved?
    payment.user.parent.billinfo.should eq(parent_old_balance + delta)
    payment.user.paid.should_not be_nil
  end

  it 'scope approved' do
    expect(Payment.approved.all.blank?).to be(false)
  end

  it 'approve with promo' do
    time_travel_to '26/11/2013'.to_datetime
    payment = payments :with_promo
    promo = Promo.find_by_code payment.promo
    user_billinfo_old = payment.user.billinfo
    payment.approve!

    payment.approved?.should_not be_nil
    (payment.user.billinfo - payment.amount - promo.amount).should eq(user_billinfo_old)
  end

  it 'approve with promo twice' do
    time_travel_to '26/11/2013'.to_datetime
    payment = payments :with_promo
    promo = Promo.find_by_code payment.promo
    payment.approve!
    user_billinfo_old = payment.user.billinfo
    second_payment = payment.dup
    second_payment.save
    second_payment.approve!

    expect(payment.approved? && second_payment.approved?).to be(true)
    expect(second_payment.user.billinfo - second_payment.amount).to eq(user_billinfo_old)
  end

end
