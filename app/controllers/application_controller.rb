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

  def set_locale
    I18n.locale = (%w(ru en).include?(params[:locale]) ? params[:locale] : nil) || I18n.default_locale
  end

  def after_login_url
    '/'
  end


end
