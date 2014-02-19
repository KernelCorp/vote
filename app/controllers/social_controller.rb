class SocialController < ApplicationController
  def fb_start
    redirect_to Social::Post::Fb.url_for_oauth "#{request.protocol + request.host_with_port}/_social/fb/finish"
  end

  def fb_finish
    Social::Post::Fb.update_api_token params[:code] if params[:code]
    render text: "OK #{params[:code]}"
  end
end
