class AjaxPasswordsController < Devise::PasswordsController

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: { _success: true, _path_to_go: false, _alert: 'sended' }
    else
      render json: { _success: false, _alert: 'fail' }
    end
  end

end
