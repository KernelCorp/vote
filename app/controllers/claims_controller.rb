class ClaimsController < ApplicationController
  before_filter :authenticate_participant!
  load_and_authorize_resource

  def create
    voting = Voting.find params[:voting_id]
    current_user.debit! MonetaryVoting(voting).cost if voting.is_a? MonetaryVoting
    current_user.claims.create! voting: voting, phone: current_user.phones.first
    flash[:notice] = t(:claim_will_be_create)
    redirect_to :back
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = t(:claim_already_exist)
    redirect_to :back
  rescue StandardError::ArgumentError => msg
    flash[:notice] = t(msg)
  end

  def index
    @votings = current_user.claims.map(&:voting)
    @phone = current_user.phone

    render 'index', :layout => 'votings'
  end
end