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
      layout = 'participants'
    elsif organization_signed_in?
      layout = 'organizations'
    else
      layout = 'application'
    end

    template = (layout == 'application') ? 'main/index' : 'main/show_signed'

    render template: template, layout: layout
  end

  def thread
    v = Voting.last
    t = Thread.new do
      puts ''
      puts "Start thread: #{v.name}. Start at: #{DateTime.now}"
      sleep v.timer.minutes
      puts ''
      puts "End thread: #{v.name}. End at: #{DateTime.now}"
    end
    t.join 0
    render :json => { rock: 'Thread exit!' }
  end
end
