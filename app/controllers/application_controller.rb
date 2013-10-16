class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, :notice => e.message
  end
end
