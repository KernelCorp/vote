class SocialPostsController < ApplicationController
  before_filter :authenticate_participant!

  def create
    type = params[:social_post].delete :type

    if type.empty? || (klass = type.safe_constantize).nil?
      return render json: { _success: false, _resource: 'social_post',
                            _errors: { type: [I18n.t('activerecord.errors.models.social_post.type.action_not_exist')] } }
    end

    post = klass.new params[:social_post]

    post.participant_id = current_participant.id
    post.voting_id = params[:other_voting_id]
    
    if post.save
      render json: { _success: true, _path_to_go: '' }
    else
      render json: { _success: false, _resource: 'social_post', _errors: post.errors.messages }
    end
  end
end
