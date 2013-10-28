class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!
  before_filter :who
  # load_and_authorize_resource

  def show
    @organization = current_user
  end

  def edit
    render :partial => 'form', :locals => { :who => @who }
  end

  def update
    current_user.update_attributes!(params[:organization])
    respond_to do |format|
      format.html {redirect_to current_user}
      format.json {render :ok}
    end
  end

  protected

  def who
    @who = current_user
  end

end
