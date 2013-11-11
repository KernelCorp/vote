class VotingsController < ApplicationController
  before_filter :authenticate_participant!, :only => [ :show, :info_about_number, :join ]
  before_filter :authenticate_organization!, :only => [ :new, :create, :edit, :update ]
  #load_and_authorize_resource

  def new
    if params[:type] == 'other'
      @voting = OtherVoting.new
      render 'new_other', :layout => 'organizations'
    else
      @voting = MonetaryVoting.new
      render 'new_monetary', :layout => 'organizations'
    end
  end

  def index
    if params[:number].nil?
      @votings = []
    else
      @votings = Voting.active.all
      @phone = Phone.new number: params[:number]
      @votings.sort! { |f, s| f.matches_count(@phone) < s.matches_count(@phone) ? 1 : -1 }
    end
    render layout: false
  end

  def create
    # TODO: do things right?
    type = params[:voting].delete :type
    if type == 'monetary_voting'
      voting = MonetaryVoting.new params[:voting]
    else
      voting = OtherVoting.new params[:voting]
    end
    voting.organization = current_organization
    voting.save!
    redirect_to organization_path
  end

  def show
    @phones = Claim.where(participant_id: current_participant.id, voting_id: params[:id]).map { |c| c.phone }
    @what = current_participant.claims.first
    render 'votings/show/active', layout: 'participants'
  end

  def widget
    @voting = Voting.find params[:id]
    @phone = current_participant.phone unless current_participant.nil?
    respond_to do |format|
      format.html {render layout: false}
      format.json {render json: @voting}
    end
  end

  def info_about_number
    @what = Claim.where(voting_id: params[:voting_id], participant_id: current_participant.id).first
    @which = params[:number].to_i
    @on = params[:position].to_i
    @rate = @what.voting.phone[@on].get_rating_for_number @which
    @spend_votes = @what.voting.phone[@on].length_to_next_rate_for_number @which
    render partial: 'number_info'
  end
end
