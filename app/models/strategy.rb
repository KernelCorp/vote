class Strategy < ActiveRecord::Base

  attr_accessible :no_avatar_zone, :friends_zone, :unknown_zone, :subscriber_zone, :too_friendly_zone, :red, :yellow, :green
  belongs_to :voting

  def total_points

  end

  def red_zone_points

  end

  def yellow_zone_points

  end

  def green_zone_points

  end

end
