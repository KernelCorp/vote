class VotingsController < ApplicationController
  before_filter :authenticate_participant!, :only => [ :show, :info_about_number, :join ]
  before_filter :authenticate_organization!, :only => [ :new, :create, :edit, :update ]
  before_filter :close_settings
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
      @votings.sort! { |first, second| first.matches_count(@phone) < second.matches_count(@phone) ? 1 : -1 }
    end
    render layout: false
  end

  def create
    # TODO: do things right
    type = params[:voting].delete :type
    if type == 'monetary_voting'
      voting = MonetaryVoting.new params[:voting]
    else
      voting = OtherVoting.new params[:voting]
    end
    voting.organization = current_user
    voting.save!
    redirect_to organization_path
  end

  def show
    @phones = Claim.where(participant_id: current_user.id, voting_id: params[:id]).map { |c| c.phone }
    @what = current_user.claims.first
  end

  def widget
    @voting = Voting.find params[:id]
    @phone = current_user.phone unless current_user.nil?
    respond_to do |format|
      format.html {render layout: false}
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

  def close_settings
    @close_settings = true
  end
end
