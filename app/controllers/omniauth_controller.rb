class OmniauthController < ApplicationController


  def facebook
    request.env['omniauth.params']['not_user'] ? facebook_access : facebook_user
    redirect
  end

  def mailru
    request.env['omniauth.params']['not_user'] ? mailru_access : mailru_user
    redirect
  end


  protected


  def redirect
    redirect_to :back
  rescue
    redirect_to root_path
  end


  def facebook_access
    Social::Post::Fb.update_api_token request.env['omniauth.auth'][:credentials][:token]
  end

  def mailru_access
  end


  def facebook_user
  end

  def mailru_user
  end
end
