class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  helper_method :after_login_url

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, :notice => e.message
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    if I18n.locale == I18n.default_locale
      {}
    else
      { locale: I18n.locale }
    end
  end

  def current_user
    current_participant || current_organization
  end

  def set_locale
    I18n.locale = (%w(ru en).include?(params[:locale]) ? params[:locale] : nil) || I18n.default_locale
  end

  def after_login_url (resource)
    type = resource.class
    if type == Organization
      stored_location_for(:organization) || '/organizations'
    elsif type == Participant
      stored_location_for(:participant) || "/participants/#{current_user.id}"
    else
      '/'
    end
  end
end
