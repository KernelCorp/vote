class PhonesController < ApplicationController
  #load_and_authorize_resource

  def create
    current_participant.phones.create! params[:phone]
    
    render json: { _success: true, _alert: 'added', _path_to_go: '' }
  rescue StandardError => e
    render json: { _success: false, _alert: 'error' }
  end

  def destroy
    phone = current_participant.phones.find params[:id]
    phone.destroy
    render json: { _success: true, _alert: 'deleted' }
  end
end