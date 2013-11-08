class ParticipantsController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :authenticate_participant!

  def show
    redirect_to votings_participant_path
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
