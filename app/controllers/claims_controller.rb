class ClaimsController < ApplicationController
  load_and_authorize_resource

  def create
    voting = Voting.find params[:voting_id]
    current_user.claims.create! voting: voting, phone: current_user.phones.first
    render :ok
  end
end