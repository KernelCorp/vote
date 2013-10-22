class VotingsController < ApplicationController
  before_filter :authenticate_participant!,  :only => [ :show, :index, :info_about_number, :join]
  before_filter :authenticate_organization!, :only => [ :new, :create, :edit, :update ]
  #load_and_authorize_resource

  def new
    @voting = Voting.new
  end

  def index
  end

  def create
    current_user.votings.create! params[:voting]
    redirect_to current_user
  end

  def join
    render :json => { :status => 'OK' }
  end

  def show
    @who = current_user
    @what = current_user.claims.first
  end

  def widget
    @voting = Voting.find params[:id]
  end

  def info_about_number
    @who = current_user
    @what = Claim.where(:voting_id => params[:id], :participant_id => current_user.id).first
    @which = params[:number].to_i
    @on = params[:position].to_i
    @rate = @what.voting.phone[@on].get_rating_for_number @which
    @spend_votes = @what.voting.phone[@on].length_to_next_rate_for_number @which
    render :partial => 'number_info'
  end
end
