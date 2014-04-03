class OmniauthController < ApplicationController

  def vkontakte
    oauthorize
  end
  def twitter
    oauthorize
  end

  def facebook
    if request.env['omniauth.params']['not_user'] 
      facebook_access
      redirect
    else
      oauthorize
    end
  end

  def odnoklassniki
    if request.env['omniauth.params']['post']
      Social::Post::Ok.create({ 
        url: request.env['omniauth.params']['post'], 
        voting: OtherVoting.find( request.env['omniauth.params']['voting'] ),
        participant: current_participant,
        omniauth: request.env['omniauth.auth'][:credentials]
      })
    end

    oauthorize
  end
  
  def mailru
    if request.env['omniauth.params']['post']
      Social::Post::Mm.create({ 
        url: request.env['omniauth.params']['post'], 
        voting: OtherVoting.find( request.env['omniauth.params']['voting'] ),
        participant: current_participant
      })
    end

    oauthorize
  end


  def finish_oauthorize
    origin = session[:oauthorize]

    if origin && !params[:phone].blank?

      origin[:info].merge!({ phone: params[:phone], password: SecureRandom.hex(8), avatar: URI.parse( origin[:avatar] ) })

      participant = Participant.new origin[:info]

      if participant.save
        render json: { _success: true, _alert: 'finish', _path_to_go: '' }
      else
        render json: { _success: false, _resource: 'participant', _errors: participant.errors.messages }
        return
      end

      participant.social_profiles.create origin[:profile]

      sign_in :participant, participant

      session[:oauthorize] = nil

    end

  end


  protected


  def oauthorize
    data = env['omniauth.auth']

    profile_hash = { provider: data[:provider], uid: data[:uid] }

    profile = Social::Profile.where profile_hash

    if profile.size > 0
      sign_in :participant, profile.first.participant
    
    elsif current_participant
      current_participant.social_profiles.create profile_hash
    
    else
      session[:oauthorize] = { info: parse_data(data), avatar: data[:info][:image], profile: profile_hash }
    end

    redirect
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
