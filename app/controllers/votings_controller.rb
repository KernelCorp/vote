class VotingsController < ApplicationController
  before_filter :authenticate_participant!, :only => [ :show, :info_about_number, :join, :update_votes_matrix]
  before_filter :authenticate_organization!, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :can_vote_for_claim?, :only => [ :update_votes_matrix ]
  #load_and_authorize_resource

  def new
    if params[:type] == 'other'
      @voting = OtherVoting.new
      render 'votings/new/other', :layout => 'organizations'
    else
      @voting = MonetaryVoting.new
      render 'votings/new/monetary', :layout => 'organizations'
    end
  end

  def edit
    @voting = Voting.find params[:id]
    render (@voting.is_a? MonetaryVoting) ? 'votings/new/monetary' : 'votings/new/other', layout: 'organizations'
  end

  def update
    @voting = Voting.find params[:id]
    return render json: { :notice => I18n.t('voting.status.cannot_update_voting') } unless can? :update, @voting
    if @voting.update_attributes params[:voting]
      render json: { _success: true, _path_to_go: organization_path }
    else
      render json: { _success: false, _path_to_go: organization_path }
    end
  end

  def index
    if params[:number].nil?
      @votings = []
    else
      @votings = Voting.active.all
      phone = Phone.new number: params[:number]

      @votings.sort_by! do |voting|
        voting[:max_coincidence] = voting.matches_count phone
        -voting[:max_coincidence]
      end
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

    render json: { _success: true, _alert: 'created', _path_to_go: organization_path }
  end

  def show
    @voting = Voting.find params[:id]
    @lead_phone_number = @voting.phone.lead_phone_number

    phones = current_participant.phones

    votes_matrix = @voting.phone

    @sorted_phones_with_checks = Array.new( 11 ){ Array.new };
    @phones_not_in_voting = Array.new( 11 ){ Array.new };
    phones.each do |phone|
      phone_with_checks = Array.new( 10 )

      count = 0
      phone_in_voting = phone.claims.where(:voting_id => @voting.id).present?
      string = ''

      phone.each_with_index do |number, i|
        position = votes_matrix.positions[i]

        place = position.place_for_number( number )
        count += 1 if place == 1

        points_to_first = phone_in_voting && place != 1 ? position.length_to_first_place_for_number( number ) : -1;

        string += number.to_s

        phone_with_checks[i] = [ number, place, points_to_first ]
      end

      if phone_in_voting
        @sorted_phones_with_checks[count].push( { id: phone.id, numbers: phone_with_checks, place: @voting.determine_place(phone) } )
      else
        @phones_not_in_voting[count].push( { id: phone.id, numbers: phone_with_checks, string: string } )
      end
    end

    if @voting.can_vote_for_claim?
      render 'votings/show/active', layout: 'participants'
    else
      lead_claim = @voting.get_lead_claim  if @voting.is_a? MonetaryVoting
      your_lead_claim = Claim.where(participant_id: current_participant.id,
                                    voting_id: @voting.id).sort_by { |c| @voting.determine_place(c.phone) }.last
      @stats = [
        ClaimStatistic.where(claim_id: lead_claim.id).sort_by(&:created_at),
        ClaimStatistic.where(claim_id: your_lead_claim.id).sort_by(&:created_at)
      ] unless lead_claim.nil? || your_lead_claim.nil?
      render 'votings/show/closed', layout: 'participants'
    end
  end

  def update_votes_matrix
    points = (params[:points]).to_i

    claim = Claim.where(participant_id: current_participant.id,
                        voting_id: params[:voting_id],
                        phone_id: params[:phone_id]).first

    monetary_voting = MonetaryVoting.find params[:voting_id]
    monetary_voting.vote_for_claim(claim, points)

    vt = VoteTransaction.new amount: points
    vt.claim = claim
    vt.participant = current_participant
    vt.save!

    render json: { _success: true, _path_to_go: '' }
  rescue Exceptions::PaymentRequiredError
    render json: { _success: false, _alert: 'cost' }
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

  def destroy
    @voting = Voting.find params[:id]
    return render json: { notice: I18n.t('voting.status.cannot_delete_active_voting') } unless can? :destroy, @voting
    @voting.destroy
    respond_to do |format|
      format.html { redirect_to :back, method: :get, status: 200 }
      format.json { render :ok }
    end
  end

  def get_timer
    voting = Voting.find params[:voting_id]
    timer = -1
    timer = voting[:end_timer].to_datetime unless voting[:end_timer].nil?
    timer = (timer - DateTime.now) * 24 * 3_600_000 unless timer.is_a? String
    render json: { timer: timer.to_i }
  end

  protected

  def can_vote_for_claim?
    voting = Voting.find params[:voting_id]
    render json: { _success: false, _alert: I18n.t('voting.status.close_for_voting') } unless voting.can_vote_for_claim?
  end

end
