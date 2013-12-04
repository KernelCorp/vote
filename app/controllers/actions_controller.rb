class ActionsController < ApplicationController

  def do
    action = Action.find(params[:id])
    stranger_hash = { }
    Stranger.attribute_names.each { |n| stranger_hash[n] = params[n] unless params[n].nil? }

    stranger = Stranger.where(params[:stranger]).first
    stranger = Stranger.create!(params[:stranger]) if stranger.nil?

    done_thing = stranger.done_things.build
    done_thing.voting_id = action.voting_id
    done_thing.what_id = action.id
    done_thing.save!
    render json: { status: 'ok', thing: 'done' }
  rescue
    render json: { status: 'failure' }
  end

end
