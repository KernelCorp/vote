class LoginController < Devise::SessionsController
  def new
    @target = resource_class.new(sign_in_params)
    clean_up_passwords(@target)
    render "#{resource_name}s/_login", :layout => 'application'
  end

  def create
    if user_signed_in?
      sign_out(current_user.class.to_s.underscore.to_sym)
    end
    resource = resource_class.find_for_database_authentication(
        { :login => params[resource_class.to_s.underscore][:login] }
      )

    good_luck = sign_in(
      resource_name,
      resource
    ) unless resource.nil? or resource.type.nil?

    respond_with resource, :location => after_sign_in_path_for(resource)
  rescue
    flash[:alert] = t 'devise.failure.admin_user.invalid'
    redirect_to :back
  end

  protected

  def after_sign_in_path_for (resource)
    stored_location_for(resource) || after_login_url(resource)
  end

end
