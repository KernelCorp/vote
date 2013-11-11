class ClaimsController < ApplicationController
  before_filter :authenticate_participant!
  load_and_authorize_resource

  def create
    phone = params[:phone].nil? ? current_participant.phones.first : current_participant.phones.create!(number: params[:phone])
    voting = Voting.find params[:voting_id]
    current_participant.debit! MonetaryVoting(voting).cost if voting.is_a? MonetaryVoting
    current_participant.claims.create! voting: voting, phone: phone
    flash[:notice] = t(:claim_will_be_create)
    status = :ok
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = t(:claim_already_exist)
    status = :already_reported
  rescue Exceptions::PaymentRequiredError
    flash[:notice] = t(msg)
    status = :payment_required
  ensure
    respond_to do |format|
      format.html {redirect_to :back}
      format.json {render json: {status: status, messages: flash[:notice]} }
    end
  end

  def index
    @votings = current_participant.claims.map(&:voting)
    @phone = current_participant.phone

    render 'index', :layout => 'participants'
  end
end
