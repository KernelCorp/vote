class MainController < ApplicationController
  def org
    redirect_to organization_path unless current_organization.nil?
  end

  def index
    redirect_to votings_participant_path unless current_participant.nil?
    redirect_to organization_path        unless current_organization.nil?
  end

  def show
    @text_page = TextPage.find params[:id]
    @links = TextPage.all

    if participant_signed_in?
      @layout = 'participants'
    elsif organization_signed_in?
      @layout = 'organizations'
    else
      @layout = 'application'
    end

    render layout: @layout
  end
end
