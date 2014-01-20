class OtherVotingsController < ApplicationController
  layout Proc.new { |controller| controller.participant_signed_in? ? 'participants' : 'voting_any_who' }
  
  def show
    @voting = OtherVoting.find params[:id]
    @voting_participants = @voting.sorted_participants

    if @voting.can_vote_for_claim?
      render 'show_active'
    else
      render 'show_closed'
    end
  end

end
