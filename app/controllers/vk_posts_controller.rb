class VkPostsController < ApplicationController
  before_filter :authenticate_participant!

  def create
    @post = current_user.vk_posts.build params[:vk_post]
    @post.voting = OtherVoting.find params[:other_voting_id]
    if @post.save
      redirect_to @post.voting
    else
      head status: :bad_request
    end
  end

end
