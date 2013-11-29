class RobokassaController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token # skip before filter if you chosen POST request for callbacks

  before_filter :create_notification
  before_filter :find_payment

  # Robokassa call this action after transaction
  def paid
    if @notification.acknowledge # check if it’s genuine Robokassa request
      @payment.approve! # project-specific code
      render text: @notification.success_response
    else
      head :bad_request
    end
  end

  # Robokassa redirect user to this action if it’s all ok
  def success
    if !@payment.approved? && @notification.acknowledge
      @payment.approve!
    end
    flash[:notice] = I18n.t 'notice.robokassa.success'
    @redirect = participant_path @payment.user
    render partial: 'payments/after_pay'
  end

  # Robokassa redirect user to this action if it’s not
  def fail
    flash[:notice] = I18n.t 'notice.robokassa.fail'
    @redirect = participant_path @payment.user
    render partial: 'payments/after_pay'
  end

  private

  def create_notification
    @notification = Robokassa::Notification.new request.raw_post, secret: '70password_sec_prize'
  end

  def find_payment
    @payment = Payment.find @notification.item_id
  end
end
