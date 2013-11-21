class UnconfirmedPhonesController < ApplicationController
  
  def create
    phone = current_participant.unconfirmed_phones.where( number: params[:unconfirmed_phone][:number] ).first

    unless phone
      phone = current_participant.unconfirmed_phones.create! number: params[:unconfirmed_phone][:number], confirmation_code: 'STANLEY'
    end

    #send sms with code

    render json: { _success: true, number: phone.number }
  rescue
    render json: { _success: false, _alert: 'error' }
  end

  def update
    phone = UnconfirmedPhone.where( number: params[:number] ).first

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