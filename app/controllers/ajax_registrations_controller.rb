class AjaxRegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        return render :json => {:success => true, :path_to_go => after_sign_up_path_for(resource)}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        return render :json => {:success => true, :path_to_go => after_inactive_sign_up_path_for(resource)}
      end
    else
      clean_up_passwords resource
      return render :json => {:success => false, :resource => resource_name, :errors => resource.errors}
    end
  end

  def update
    @close_settings = false
    if params[resource_name].nil?
      params[resource_name] = params[:who_change_email].nil? ? params[:who_change_password] : params[:who_change_email]
    end
    documents = params[resource_name].delete :documents # Special for organization, nothing break if leave it here
    success = if need_password? params[resource_name]
      current_user.update_with_password params[resource_name]
    else
      params[resource_name].delete :current_password
      current_user.update_without_password params[resource_name]
    end

    if success
      sign_in resource_name, resource, :bypass => true
      flash.now[:notice] = { ok: success }
    else
      clean_up_passwords resource
      flash.now[:alert] = { errors: current_user.errors.messages }
    end

    if resource_class == Organization && success && !documents.nil?
      documents.each { |d| current_user.documents.create! attachment: d }
    end
    render "#{resource_name}s/show", layout: "#{resource_name}s"
  end

  protected

  def need_password? (params)
    params[:email].present? ||
      params[:password].present?
  end
end
