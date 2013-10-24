class PaymentsController < ApplicationController
  before_filter :authenticate_participant!
  def new
    @payment = Payment.new user_id: current_user
  end

  def create
    @payment = Payment.create! params[:payment]
    respond_to do |format|
      format.html
      format.json {render @payment}
    end
  end
end
