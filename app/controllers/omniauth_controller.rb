class OmniauthController < ApplicationController


  def facebook
    if request.env['omniauth.params']['not_user'] 
      facebook_access 
    end
    redirect
  end

  def mailru
    redirect
  end


  protected


  def redirect
    redirect_to( request.env['omniauth.params']['redirect'] || :back )
  rescue
    redirect_to root_path
  end


  def facebook_access
    Social::Post::Fb.update_api_token request.env['omniauth.auth'][:credentials][:token]
  end
end
