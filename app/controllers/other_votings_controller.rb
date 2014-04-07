class OtherVotingsController < ApplicationController
  layout Proc.new { |controller| controller.participant_signed_in? ? 'participants' : 'voting_any_who' }
  
  def show
    @voting = OtherVoting.find_by_slug params[:id]
    @voting.complete_if_necessary!
    if @voting.can_vote_for_claim?
      render 'show_active'
    else
      render 'show_close'
    end
  end

end
