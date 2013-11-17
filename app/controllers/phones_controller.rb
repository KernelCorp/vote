class VotingsController < ApplicationController
  load_and_authorize_resource

  def create
    current_participant.phones.create! params[:phone]
    success = true
    render json: { _success: true, _alert: 'success' }
  rescue StandardError => e
    render json: { _success: false, _alert: 'phone' }
  end
end