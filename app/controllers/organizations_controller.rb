class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!
  before_filter :close_settings
  # load_and_authorize_resource

  def show
  end

  def edit
    render :partial => 'form', :locals => { :who => current_user }
  end

  def drop_document
    drop = current_user.documents.find(params[:id])
    drop.destroy unless drop.nil?
    render :json => { :ok => true }
  end

  def drop_voting
    voting = current_user.votings.find(params[:id])
    voting.destroy unless voting.nil?
    render :json => { :ok => true }
  end

  protected

  def close_settings
    @close_settings = true
  end
end
