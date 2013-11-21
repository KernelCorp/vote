class UnconfirmedPhonesController < ApplicationController
  before_filter :authenticate_participant!

  def create
    phone = current_participant.unconfirmed_phones.where( number: params[:unconfirmed_phone][:number] ).first

    unless phone
      phone = current_participant.unconfirmed_phones.create! number: params[:unconfirmed_phone][:number]
    end

    phone.confirmation_code = SecureRandom.hex 3
    phone.save!

    msg = I18n.t 'participant.phone_code.sms', code: phone.confirmation_code

    SMSMailer.send_sms( '7'<<phone, msg )

    render json: { _success: true, number: phone.number }
  rescue
    render json: { _success: false, _alert: 'error' }
  end

  def update
    phone = current_participant.unconfirmed_phones.where( number: params[:number] ).first

    unless phone
      return render json: { _success: false, _alert: 'unconfirmed' }
    end

    if phone.confirmation_code != params[:confirmation_code]
      return render json: { _success: false, _alert: 'code' }
    end

    unless current_participant.phones.create number: phone.number
      return render json: { _success: false, _alert: 'phone' }
    end

    phone.destroy

    render json: { _success: true, phone: params[:number] }
  end
end