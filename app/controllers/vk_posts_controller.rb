class VkPostsController < ApplicationController
  before_filter :authenticate_participant!

  def create
    @post = current_user.vk_posts.build params[:vk_posts]
    @post.save!
    head :ok
  rescue
    render jsom: {status: 500, errors: @post.errors}
  end

end
