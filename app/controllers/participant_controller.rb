class ParticipantController < ApplicationController
  before_filter :authenticate_user!

  def show
    # @who = User.find(params[:id])
    # @what = @who.claims.first
  end
end
