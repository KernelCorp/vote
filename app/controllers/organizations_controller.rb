class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!
  before_filter :who
  # load_and_authorize_resource

  def show
  end

  def edit
    render :partial => 'form', :locals => { :who => @who }
  end

  def update
    debugger
    if params[:organization].nil?
      params[:organization] = params[:who_change_email].nil? ? params[:who_change_password] : params[:who_change_email]
    end
    documents = params[:organization].delete :documents
    success = if need_password?(params[:organization])
      current_user.update_with_password(params[:organization])
    else
      params[:organization].delete(:current_password)
      current_user.update_without_password(params[:organization])
    end

    if success
      if !documents.nil? then
        documents.each do |d|
          current_user.documents.create!({ :attachment => d })
        end
      end
      flash[:notice] = { :ok => success }
      render :show, :layout => 'organization_open_settings'
    else
      flash[:alert] = { :errors => current_user.errors.messages }
      render :show, :layout => 'organization_open_settings'
    end
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

  def who
    @who = current_user
  end

  def need_password?(params)
    params[:email].present? ||
      params[:current_password].present?
  end

end
