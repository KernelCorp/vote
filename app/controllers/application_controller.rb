class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception
  helper_method :after_login_url

  def after_login_url
    return new_user_session_url unless user_signed_in?

    case current_user.class.name
    when 'Participant'
      root_url
    when 'Organization'
      edit_organization_registration_url
    else
      root_url
    end
  end

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, :notice => e.message
  end
end
