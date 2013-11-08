class MainController < ApplicationController
  def org
    redirect_to organization_path unless current_organization.nil?
  end

  def index
    redirect_to votings_participant_path unless current_participant.nil?
    redirect_to organization_path        unless current_organization.nil?
  end
end
