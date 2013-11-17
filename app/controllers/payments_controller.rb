class PaymentsController < ApplicationController
  before_filter :authenticate_participant!

  def new
    @payment = Payment.new user_id: current_participant
    render partial: 'new'
  end

  def create
    @payment = current_participant.payments.create! params[:payment]
    respond_to do |format|
      format.html { render partial: 'create' }
      format.json { render @payment }
    end
  end
end
