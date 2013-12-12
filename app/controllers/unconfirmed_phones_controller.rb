class UnconfirmedPhonesController < ApplicationController
  before_filter :authenticate_participant!

  def create
    return render json: { _success: false, _alert: 'unconfirmed' } if current_participant.phones.empty?

    phone = current_participant.unconfirmed_phones.where( number: params[:unconfirmed_phone][:number] ).first
    phone = current_participant.unconfirmed_phones.create_and_send_sms! number: params[:unconfirmed_phone][:number] unless phone

    render json: { _success: true, number: phone.number}
  rescue
    render json: { _success: false, _alert: 'error' }
  end

  def update
    phone = current_participant.unconfirmed_phones.where( number: params[:number] ).first

    return render json: { _success: false, _alert: 'unconfirmed' } unless phone
    return render json: { _success: false, _alert: 'code' } if phone.confirmation_code != params[:confirmation_code]
    return render json: { _success: false, _alert: 'phone' } unless current_participant.phones.create number: phone.number

    phone.destroy
    render json: { _success: true, _path_to_go: '', phone: params[:number] }
  end
end
