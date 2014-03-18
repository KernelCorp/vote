class OmniauthController < ApplicationController

  def vkontakte
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


  def finish_oauthorize
    origin = session['oauthorize']

    if origin && !params[:phone].blank?

      origin[:info].merge! { phone: params[:phone], password: SecureRandom.hex(8), avatar: URI.parse( origin[:avatar] ) }

      participant = Participant.new origin[:info]
      participant.save
      participant.social_profiles.create origin[:profile]

      sign_in participant

    end

    redirect_to root_path, flash: { oauthorize: 'finish' }
  end


  protected


  def oauthorize
    data = env['omniauth.auth']

    profile_hash = { provider: data[:provider], uid: data[:uid] }

    profile = Social::Profile.where profile_hash
    return sign_in( profile.first.participant ) unless profile.empty?

    return current_participant.social_profiles.create( profile_hash ) if current_participant

    session['oauthorize'] = { info: parse_data(data), avatar: data[:info][:image], profile: profile_hash }

    redirect_to root_path, flash: { oauthorize: 'start' }
  end

  def parse_data( data )
    info = data[:info]
    extra = data[:extra][:raw_info]

    hash = {
      firstname: info[:first_name],
      secondname: info[:last_name]
    }

    case data[:provider]
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
