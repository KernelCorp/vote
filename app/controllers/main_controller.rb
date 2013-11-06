class MainController < ApplicationController
  def org
  end

  def index
    redirect_to votings_participant_path unless current_participant.nil?
  end
end
