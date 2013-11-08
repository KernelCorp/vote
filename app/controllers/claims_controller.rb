class ClaimsController < ApplicationController
  before_filter :authenticate_participant!
  load_and_authorize_resource

  def create
    phone = params[:phone].nil? ? current_participant.phones.first : current_participant.phones.create!(number: params[:phone])
    voting = Voting.find params[:voting_id]
    current_participant.debit! MonetaryVoting(voting).cost if voting.is_a? MonetaryVoting
    current_participant.claims.create! voting: voting, phone: phone
    flash[:notice] = t(:claim_will_be_create)
    redirect_to :back
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = t(:claim_already_exist)
    redirect_to :back
  rescue StandardError::ArgumentError => msg
    flash[:notice] = t(msg)
  end

  def index
    @votings = current_participant.claims.map(&:voting)
    @phone = current_participant.phone

    render 'index', :layout => 'participants'
  end
end
