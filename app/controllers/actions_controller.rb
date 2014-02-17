class ActionsController < ApplicationController
  before_filter :set_access_control_headers

  def do
    org = Organization.find_by_email params[:login]
    action = Action.find(params[:action_id])
    if !org.nil? && org.valid_password?(params[:password]) && org.votings.include?(action.other_voting)
      fail 'you can not do this action' unless action.can_do?
      stranger_hash = { }
      Stranger.attribute_names.each { |n| stranger_hash[n] = params[n] unless params[n].nil? }
      stranger = Stranger.find_or_create_by_email stranger_hash['email']
      stranger.update_attributes! stranger_hash
      done_thing = stranger.done_things.create do |dt|
        dt.voting_id = action.voting_id
        dt.what_id = action.id
      end
      render json: { status: 'ok', thing: 'done' }
    else
      head :unauthorized
    end
  rescue => e
    render json: { success: false, status: 'failure', errors: e.message}
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(',')
  end

end
