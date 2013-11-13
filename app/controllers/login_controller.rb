#coding: utf-8
class LoginController < Devise::SessionsController
  def new
    @target = resource_class.new(sign_in_params)
    clean_up_passwords(@target)
    render "#{resource_name}s/_login", :layout => 'application'
  end

  def create

    # If user sign in, return with error
    #if user_signed_in?
    #  return render :json => { :success => false, :errors => 'logout' }
    #end

    self.resource = warden.authenticate(auth_options)
    self.resource = authenticate_through_one_time_pass if self.resource.nil?
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    location = after_sign_in_path_for(resource)

    return render :json => { :success => true, :path_to_go => location }
  rescue
    return render :json => { :success => false, :errors => 'login' }
  end


  protected

  def after_sign_in_path_for (resource)
    stored_location_for(resource) || after_login_url(resource)
  end

  def authenticate_through_one_time_pass
    user = User.find_first_by_auth_conditions login: params[:login]
    if (user.is_a? Participant) && (user.one_time_password == params[:password])
      user.one_time_password = nil
      user.save!
    else
      user = nil
    end
    user
  end

end
