class ParticipantsController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def show_active_votings
    @votings = Voting.active.all
    @phone = current_user.phone
    @votings.sort! do |first, second|
      first.matches_count(@phone) < second.matches_count(@phone) ? 1 : -1
    end

    render :layout => 'participants'
  end
end
