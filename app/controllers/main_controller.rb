class MainController < ApplicationController
  def org
    redirect_to organization_path unless current_organization.nil?
  end

  def index
    redirect_to votings_participant_path and return unless current_participant.nil?
    redirect_to organization_path and return        unless current_organization.nil?
    redirect_to votings_path
  end

  def show
    @text_page = TextPage.find params[:id]
    @links = TextPage.all

    if participant_signed_in?
      layout = 'participants'
    elsif organization_signed_in?
      layout = 'organizations'
    else
      layout = 'application'
    end

    template = (layout == 'application') ? 'main/index' : 'main/show_signed'

    render template: template, layout: layout
  end

end
