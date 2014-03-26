class Strategy < ActiveRecord::Base

  attr_accessible :no_avatar_zone, :friends_zone, :unknown_zone, :subscriber_zone, :too_friendly_zone, :red, :yellow, :green
  belongs_to :voting

  def total_points(state)
    self.red_zone_points(state) + self.yellow_zone_points(state) + self.green_zone_points(state)
  end

  def red_zone_points(state)
    red_points = 0
    for_each_voter_with_cache(state) do |voter|
      red_points += self.red if voter.zone == 2
    end
    red_points
  end

  def yellow_zone_points(state)
    yellow_points = 0
    for_each_voter_with_cache(state) do |voter|
      yellow_points += self.yellow if voter.zone == 1
    end
    yellow_points
  end

  def green_zone_points(state)
    green_points = 0
    for_each_voter_with_cache(state) do |voter|
      green_points += self.green if voter.zone == 0
    end
    green_points
  end

  protected
  def for_each_voter_with_cache(state)
    get_voters_zones(state) if @cache.nil?
    @cache[state.id].each do |voter|
      yield voter
    end
  end

  def get_voters_zones(state)
    @cache = {state.id => state.voters.all }
    @cache[state.id].each do |voter|
      zone = 1 #default zone
      zone = self.friends_zone    if voter.relationship == 'friend'
      zone = self.subscriber_zone if voter.relationship == 'subscriber'
      zone = self.unknown_zone    if voter.relationship == 'unknown'
      zone = [zone, self.no_avatar_zone].max if voter.has_avatar == false
      zone = [zone, self.too_friendly_zone].max if voter.too_friendly == true
      voter.zone = zone
    end
  end
end
