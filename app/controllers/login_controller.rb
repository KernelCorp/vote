class LoginController < Devise::SessionsController

#  def create
#    resource = User.find_for_database_authentication(
#        { :login => params[:user][:login] }
#      )
#
#    sign_in(
#      :user,
#      resource.type.constantize.send(:find, resource.id)
#    ) unless resource.nil? or resource.type.nil?
#
#    respond_with resource, :location => after_sign_in_path_for(resource)
#  end

  def after_sign_in_path_for (resource)
    stored_location_for(resource) || after_login_url
  end
end
