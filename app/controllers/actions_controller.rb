class ActionsController < ApplicationController

  def do
    action = Action.find(params[:action_id])
    stranger_hash = { }
    Stranger.attribute_names.each { |n| stranger_hash[n] = params[n] unless params[n].nil? }

    stranger = Stranger.where(params[:stranger]).first
    stranger = Stranger.create!(params[:stranger]) if stranger.nil?

    done_thing = stranger.done_things.create do |dt|
      dt.voting_id = action.voting_id
      dt.what_id = action.id
    end
    render json: { status: 'ok', thing: 'done' }
  rescue
    render json: { status: 'failure' }
  end

end
