class LoginController < Devise::SessionsController

  def new
    @target = resource_class.new(sign_in_params)
    clean_up_passwords(@target)
    render "#{resource_class.to_s.underscore}/login"
  end

  def create
    debugger
    resource = resource_class.find_for_database_authentication(
        { :login => params[resource_class.to_s.underscore][:login] }
      )

    sign_in(
      resource_name,
      resource.type.constantize.send(:find, resource.id)
    ) unless resource.nil? or resource.type.nil?

    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  def after_sign_in_path_for (resource)
    stored_location_for(resource) || after_login_url
  end
end
