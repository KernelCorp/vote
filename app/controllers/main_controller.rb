class MainController < ApplicationController
  def org
    redirect_to organization_path unless current_organization.nil?
  end

  def index
    redirect_to votings_participant_path unless current_participant.nil?
    redirect_to organization_path        unless current_organization.nil?
  end

  def text
    _layout = 'application'
    if participant_signed_in?
      _layout = 'participants'
    elsif organization_signed_in?
      _layout = 'organizations'
    end
    render layout: _layout
  end
end
