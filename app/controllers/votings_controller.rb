class VotingsController < ApplicationController
  before_filter :authenticate_participant!, :only => [ :show, :info_about_number, :join]
  before_filter :authenticate_organization!, :only => [ :new, :create, :edit, :update, :destroy ]
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
    @voting = Voting.find params[:id]
    @lead_phone_number = @voting.phone.lead_phone_number
    @phones = Claim.where(participant_id: current_participant.id, voting_id: params[:id]).map { |c| c.phone }

    votes_matrix = @voting.phone

    @sorted_phones_with_checks = Array.new( 11 ){ Array.new };
    @phones.each do |phone|
      phone_with_checks = Array.new( 10 )
      count = 0
      phone.each_with_index do |number, i|
        position = votes_matrix.positions[i]
        place = position.place_for_number( number )
        points_to_first = position.length_to_first_place_for_number( number )
        count += 1 if place == 1
        phone_with_checks[i] = [ number, place, points_to_first ]
      end
      @sorted_phones_with_checks[count].push( { id: phone.id, numbers: phone_with_checks, place: @voting.determine_place(phone) } )
    end

    if @voting.status != 'active'
      render 'votings/show/active', layout: 'participants'
    else # @voting.status == 'closed'
      render 'votings/show/closed', layout: 'participants'
    end
  end

  def update_votes_matrix
    points = (params[:points]).to_i

    claim = Claim.where(participant_id: current_participant.id, voting_id: params[:voting_id], phone_id: params[:phone_id])
    
    monetary_voting = MonetaryVoting.find params[:voting_id]
    
    monetary_voting.vote_for_claim( claim, points )

    render json: { _success: true }

  rescue Exceptions::PaymentRequiredError

    render json: { _success: false, _alert: 'cost' }

=begin
    voting = Voting.find params[:voting_id]
    phone = Phone.find params[:phone_id]
    points = (params[:points]).to_i

    return render json: { _success: false } if points <= 0

    #check if participant have enough points

    votes_matrix = voting.phone

    #sorting
    sorted_numbers = Array.new

    phone.each_with_index do |number, i|
      points_to_first = votes_matrix.positions[i].length_to_first_place_for_number( number )
      sorted_numbers.push({ i: i, number: number, points_to_first: points_to_first }) if points_to_first != -1
    end

    sorted_numbers.sort_by! { |x| x[:points_to_first] }

    #allocate points
    sorted_numbers.each do |number|
      change = [ points, number[:points_to_first] ].min
      
      matrix_cell = votes_matrix.positions[number[:i]].votes[number[:number]];
      matrix_cell.votes_count += change;
      matrix_cell.save!

      points -= change
      break if points <= 0
    end

    render json: { _success: true }
=end
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
    @voting.destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.json {render :ok}
    end
  end
end
