class VotingsController < ApplicationController
  before_filter :authenticate_participant!,  :only => [ :show, :info_about_number, :join]
  before_filter :authenticate_organization!, :only => [ :new, :create, :edit, :update ]
  before_filter :who
  #load_and_authorize_resource

  def new
    @voting = Voting.new
    render 'new', :layout => 'organizations'
  end

  def index
    @votings = Voting.active.all
  end

  def create
    current_user.votings.create! params[:voting]
    redirect_to '/'
  end

  def join
    render :json => { :status => 'OK' }
  end

  def show
    @what = @who.claims.first
  end

  def widget
    @voting = Voting.find params[:id]
    respond_to do |format|
      format.html {render layout: 'application'}
      format.json {render json: @voting}
    end
  end

  def info_about_number
    @what = Claim.where(:voting_id => params[:voting_id], :participant_id => current_user.id).first
    @which = params[:number].to_i
    @on = params[:position].to_i
    @rate = @what.voting.phone[@on].get_rating_for_number @which
    @spend_votes = @what.voting.phone[@on].length_to_next_rate_for_number @which
    render :partial => 'number_info'
  end

  private
  def who
    @who = current_user
  end
end
