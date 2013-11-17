class ClaimsController < ApplicationController
  before_filter :authenticate_participant!
  #load_and_authorize_resource

  def create
    voting = Voting.find params[:voting_id]

    #return render json: { _success: false, _alert: 'not_monetary' } unless voting.is_a? MonetaryVoting

    begin
      phone = Phone.find_or_create_by_participant_id_and_number(current_participant.id, params[:claim][:phone])
    rescue ActiveRecord::RecordInvalid
      return render json: { _success: false, _alert: 'phone' }
    end

    begin
      current_participant.debit! voting.cost if voting.is_a? MonetaryVoting
    rescue Exceptions::PaymentRequiredError
      return render json: { _success: false, _alert: 'cost' }
    end

    begin
      current_participant.claims.create! voting: voting, phone: phone
    rescue ActiveRecord::RecordInvalid
      return render json: { _success: false, _alert: 'claim' }
    end

    render json: { _success: true, _alert: 'success', _reload: true }
  end

  def index
    @votings = current_participant.claims.map &:voting
    @phone = current_participant.phone

    render 'index', :layout => 'participants'
  end
end
