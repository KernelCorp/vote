class PhonesController < ApplicationController
  #load_and_authorize_resource

  def create
    current_participant.phones.create! params[:phone]
    success = true
    render json: { _success: true, _alert: 'added', _reload: true }
  rescue StandardError => e
    render json: { _success: false, _alert: 'error' }
  end
end