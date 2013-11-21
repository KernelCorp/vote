class AjaxRegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        return render json: { _success: true, _path_to_go: after_sign_up_path_for(resource)}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        return render json: { _success: true, _path_to_go: after_inactive_sign_up_path_for(resource)}
      end
    else
      clean_up_passwords resource
      return render json: { _success: false, _resource: resource_name, _errors: resource.errors.messages}
    end
  end

  def update
    @close_settings = false
    form_symbol = resource_name
    if params[resource_name].nil?
      form_symbol = params[:who_change_email].nil? ? :who_change_password : :who_change_email
      params[resource_name] = params[form_symbol]
    end
    documents = params[resource_name].delete :documents # Special for organization, nothing break if leave it here
    success = if resource_class.need_password? params[resource_name]
      current_user.update_with_password params[resource_name]
    else
      params[resource_name].delete :current_password
      current_user.update_without_password params[resource_name]
    end

    hash = { _success: success }
    if success
      if resource_class == Organization
        documents.each { |d| current_organization.documents.create! attachment: d } if !documents.nil?
        resource[:is_confirmed] = 0
        resource.save
      end
      sign_in resource_name, resource, :bypass => true
      hash[:_alert] = 'edited'
      hash[:_path_to_go] = ''
    else
      clean_up_passwords current_user
      hash[:_resource] = form_symbol
      hash[:_errors] = current_user.errors.messages
    end

    render json: hash
  end
end
