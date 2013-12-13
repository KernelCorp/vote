class PaymentsController < ApplicationController
  before_filter :authenticate_participant!

  def new
    @payment = Payment.new user_id: current_participant
    render partial: 'new'
  end

  def create
    @payment = current_participant.payments.create! params[:payment]
    @promo = Promo.find_by_code @payment.promo
    partial = ''
    with_format(:html) { partial = render_to_string 'payments/_create', layout: false }
    render json: { _success: true,  _content: partial }
  rescue
    render json: { _success: false, _alert: 'error' }
  end
end
