class WidgetController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :get_score, :test ]

  def show
  end

  def test
  end

  def get_score
  end

  def add_phone
    render :json => { :status => 'OK' }
  end

  def check_phone
    render :json => { :status => 'OK' }
  end
end
