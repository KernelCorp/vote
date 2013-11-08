class PaymentsController < ApplicationController
  before_filter :authenticate_participant!

  def new
    @payment = Payment.new user_id: current_participant
  end

  def create
    @payment = Payment.create! params[:payment]
    respond_to do |format|
      format.html
      format.json {render @payment}
    end
  end
end
