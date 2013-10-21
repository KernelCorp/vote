class VotingsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :widget ]

  def new
    @voting = Voting.new
  end

  def create
    current_user.votings.create! params[:voting]
  end

  def join
    render :json => { :status => 'OK' }
  end

  def show
    @who = current_user
    @what = current_user.claims.first
  end

  def widget
  end

  def info_about_number
    @who = current_user
    @what = Claim.where(:voting_id => params[:id], :participant_id => current_user.id).first
    @which = params[:number].to_i
    @on = params[:position].to_i
    @rate = @what.voting.phone[@on].get_rating_for_number @which
    render :partial => 'voting/number_info'
  end
end
