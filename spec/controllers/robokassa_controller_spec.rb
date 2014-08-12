require 'spec_helper'

describe RobokassaController, :type => :controller do
  it 'paid' do
    payment = payments(:not_approved)
    post :paid, {InvId: payment.id, SignatureValue: Digest::MD5.hexdigest("11:#{payment.id}:prize_password35"),
        OutSum: payment.amount }
  end
end