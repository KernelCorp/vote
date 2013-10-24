class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!
  load_and_authorize_resource

  def show
    @organization = current_user
  end

  def edit
    @organization = current_user
    respond_to do |format|
      format.html
      format.json {render json: @organization}
    end
  end

  def update
    current_user.update_attributes!(params[:organization])
    respond_to do |format|
      format.html {redirect_to current_user}
      format.json {render :ok}
    end
  end

end
