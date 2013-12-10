class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!
  # load_and_authorize_resource

  def show
  end

  def edit
    render :partial => 'form', :locals => { :who => current_organization }
  end

  def drop_document
    drop = current_organization.documents.find(params[:id])
    drop.drop_in_fire unless drop.nil?
    render :json => { :ok => true }
  end

  def drop_voting
    voting = current_organization.votings.find(params[:id])
    voting.destroy unless voting.nil?
    render :json => { :ok => true }
  end
end
