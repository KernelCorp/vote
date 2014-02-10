class ClaimsController < ApplicationController
  before_filter :authenticate_participant!
  before_filter :can_register_in_voting?, :only => [ :create ]
  #load_and_authorize_resource

  def create
    voting = Voting.find params[:voting_id]

    begin
      phone = Phone.find_or_create_by_participant_id_and_number(current_participant.id, params[:claim][:phone])
    rescue ActiveRecord::RecordInvalid
      return render json: { _success: false, _alert: 'phone' }
    end

    begin
      current_participant.debit! voting.cost if voting.is_a? MonetaryVoting
    rescue Exceptions::PaymentRequiredError
      return render json: { _success: false, _alert: 'cost' }
    end

    begin
      claim = current_participant.claims.create! voting: voting, phone: phone
    rescue ActiveRecord::RecordInvalid
      return render json: { _success: false, _alert: 'claim' }
    end

    render json: { _success: true, _alert: 'success', _path_to_go: '' }
  end

  def index
    @votings = current_participant.claims.map(&:voting).uniq

    @votings.sort_by! do |voting|
      voting[:max_coincidence] = 0
      current_participant.phones.each do |phone|
        voting[:max_coincidence] = [ voting[:max_coincidence], voting.matches_count(phone) ].max
      end
      -voting[:max_coincidence]
    end
    @votings += current_participant.vk_posts.map(&:voting).uniq
    render 'index', :layout => 'participants'
  end

  protected

  def can_register_in_voting?
    voting = Voting.find params[:voting_id]
    render json: { _success: false, _alert: I18n.t('voting.status.close_for_registration') } unless voting.can_register_in_voting?
  end

end
