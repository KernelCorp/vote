class SocialPostsController < ApplicationController
  before_filter :authenticate_participant!

  def create
    type = params[:social_post_base].delete :type

    if type.empty? || (klass = type.safe_constantize).nil?
      return render json: { _success: false, _resource: 'social_post',
                            _errors: { type: [I18n.t('activerecord.errors.models.social_post.type.net_not_exist')] } }
    end

    post = klass.new params[:social_post_base]

    post.participant_id = current_participant.id
    post.voting_id = OtherVoting.find(params[:other_voting_id]).id
    
    if post.save
      render json: { _success: true, _path_to_go: '' }
    else
      render json: { _success: false, _resource: 'social_post', _errors: post.errors.messages }
    end
  end
end
