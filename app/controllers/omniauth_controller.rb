class OmniauthController < ApplicationController

  def vk
    oauthorize
    redirect
  end
  def mailru
    oauthorize
    redirect
  end
  def twitter
    oauthorize
    redirect
  end

  def facebook
    if request.env['omniauth.params']['not_user'] 
      facebook_access 
    else
      oauthorize
    end
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
    else
      oauthorize
    end
    redirect
  end


  protected


  def oauthorize
    info = env["omniauth.auth"]


    profile_hash = provider: info[:provider], uid: info[:uid]


    profile = Social::Profile.where profile_hash
    return sign_in( profile.first.participant ) unless profile.empty?


    if current_participant
      participant = current_participant
    else
      participant = Participant.create parse_info info

      if info[:image]
        participant.avatar = URI.parse info[:image]
        participant.save
      end
      
      sign_in( participant )
    end

    participant.social_profiles.create profile_hash
  end

  def parse_info( info )
    hash = {
      firstname: info[:first_name],
      secondname: info[:last_name]
    }

    extra = info[:extra][:raw_info]

    case info[:provider]
    when 'vkontakte'
      hash[:gender] = extra[:sex] == 2 if extra[:sex]
      hash[:birthdate] = extra[:bdate] if extra[:bdate]
    end

    return hash
  end


  def redirect
    redirect_to( request.env['omniauth.params']['redirect'] || root_path )
  end


  def facebook_access
    Social::Post::Fb.update_api_token request.env['omniauth.auth'][:credentials][:token]
  end
  
end
