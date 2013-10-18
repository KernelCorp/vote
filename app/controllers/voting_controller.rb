class VotingController < ApplicationController
  before_filter :authenticate_user!, :except => [ :widget ]

  def join
    render :json => { :status => 'OK' }
  end

  def show
    @who = current_user
    @what = current_user.claims.first
  end

  def widget
  end

  def info_about_number
    @who = current_user
    @what = Claim.where(:voting_id => params[:id], :participant_id => current_user.id).first
    @target = params[:number]
    @position = params[:position]
    render :partial => 'voting/number_info'
  end
end
