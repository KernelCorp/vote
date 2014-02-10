#ecoding: utf-8
class ParticipantsController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :authenticate_participant!
  skip_before_filter :authenticate_participant!, only: [:recover_password]

  def recover_password
    user = User.find_by_phone params[:participant][:phone]
    if user.nil?
      success = false
      alert = 'unfound'
    else
      user.generate_one_time_password!
      if SMSMailer.send_sms '7'.concat(user.phone),
                            "Одноразовый пароль для входа на сайт toprize.ru - #{user.one_time_password}"
        success = true
      else
        success = false
        alert = 'sms'
      end
    end
    render json: { _success: success, _alert: alert }
  end

  def invite_via_social
  end

  def show
    redirect_to votings_participant_path
  end

  def create_invite
    email = params[:email].nil? ? params[:some][:email] : params[:email]
    method = params[:method]
    voting_id = params[:voting_id] if method == 'invite_to_vote'
    phone = params[:some][:phone] unless params[:some].nil?

    unless phone.blank?
      msg = I18n.t 'participant.invite.sms', id: current_participant.id
      SMSMailer.send_sms phone, msg
    end

    unless email.blank?
      args = [ email, current_participant ]
      args << Voting.find(voting_id) unless voting_id.nil?
      ParticipantMailer.send(method, *args).deliver
    end

    if email.blank? && phone.blank?
      render json: { _success: false, _alert: 'not_sended' }
    else
      render json: { _success: true, _alert: 'sended' }
    end
  rescue =>e
    logger.error e.message
    render json: { _success: false, _alert: 'not_sended' }
  end

  def show_active_votings
    @votings = MonetaryVoting.active.all
    @votings.sort_by! do |voting|
      voting[:max_coincidence] = 0
      current_participant.phones.each do |phone|
        voting[:max_coincidence] = [ voting[:max_coincidence], voting.matches_count(phone) ].max
      end
      -voting[:max_coincidence]
    end
    add_other_and_render!
  end

  def show_closed_votings
    @votings = MonetaryVoting.closed.all
    add_other_and_render!
  end

  protected
  def add_other_and_render!
    @votings += OtherVoting.active.all
    render layout: 'participants'
  end
end
