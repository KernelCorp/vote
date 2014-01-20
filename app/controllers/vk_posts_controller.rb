class VkPostsController < ApplicationController
  before_filter :authenticate_participant!

  def create
    post_id = params[:vk_post][:link].match(/-?\d+_\d+/)[0]

    @post = current_user.vk_posts.build post_id: post_id
    @post.voting = OtherVoting.find params[:other_voting_id]
    @post.participant = current_participant
    if @post.save
      redirect_to @post.voting
    else
      render status: :bad_request, errors: @post.errors
    end
  end

end
