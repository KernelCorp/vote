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

  def odnoklassniki
    if request.env['omniauth.params']['post']
      ok = Social::Post::Ok.new({ 
        url: request.env['omniauth.params']['post'], 
        voting: OtherVoting.find( request.env['omniauth.params']['voting'] ),
        participant: current_participant,
        omniauth: request.env['omniauth.auth'][:credentials]
      })

      ok.save
      puts ok.errors
    end
    redirect
  end


  protected


  def redirect
    redirect_to( request.env['omniauth.params']['redirect'] || root_path )
  end


  def facebook_access
    Social::Post::Fb.update_api_token request.env['omniauth.auth'][:credentials][:token]
  end
end
