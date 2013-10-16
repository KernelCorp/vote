class VotingController < ApplicationController
  before_filter :authenticate_user!, :except => [ :widget ]

  def join
    render :json => { :status => 'OK' }
  end

  def show
  end

  def widget
  end
end
