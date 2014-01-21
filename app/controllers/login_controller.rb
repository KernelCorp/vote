#coding: utf-8
class LoginController < Devise::SessionsController
  def new
    @target = resource_class.new sign_in_params
    clean_up_passwords @target
    render "#{resource_name}s/_login", :layout => 'application' rescue redirect_to :root, flash: { login_needed: true }
  end

  def create
    self.resource = warden.authenticate(auth_options)
    self.resource = authenticate_through_one_time_pass if self.resource.nil?
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    return render json: { _success: true, _path_to_go: after_sign_in_path_for(resource) }
  rescue
    return render json: { _success: false, _error: 'login' }
  end


  protected

  def after_sign_in_path_for (resource)
    request.referrer || after_login_url(resource)
  end

  def authenticate_through_one_time_pass
    user = User.find_first_by_auth_conditions login: params[:participant][:login]
    if (user.is_a? Participant) && (user.one_time_password == params[:participant][:password])
      user.one_time_password = nil
      user.save!
    else
      user = nil
    end
    user
  end

end
