#coding: utf-8
class ParticipantsController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :authenticate_participant!
  skip_before_filter :authenticate_participant!, only: [:recover_password]

  def recover_password
    user = User.find_by_phone params[:phone]
    if user.nil?
      success = false
    else
      user.genrate_one_time_password!
      if SMSMailer.send_sms '7'.concat(user.phone),
                            "Одноразовый пароль для входа на сайт toprize.ru - #{user.one_time_password}"
        success = true
      else
        success false
      end
    end
    redirect_to '/'
  end

  def show
    redirect_to votings_participant_path
  end

  def create_invite
    ParticipantMailer.invite(params[:email], current_participant).deliver
    render json: { _success: true, _alert: 'sended' }
  end

  def show_active_votings
    @votings = Voting.active.all
    @phone = current_participant.phone
    @votings.sort! do |first, second|
      first.matches_count(@phone) < second.matches_count(@phone) ? 1 : -1
    end

    render :layout => 'participants'
  end

  def show_closed_votings
    @votings = Voting.closed.all
    @phone = current_participant.phone
    @votings.sort! do |first, second|
      first.matches_count(@phone) < second.matches_count(@phone) ? 1 : -1
    end

    render :layout => 'participants'
  end
end
