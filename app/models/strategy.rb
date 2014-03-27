class Strategy < ActiveRecord::Base

  ZONES = {red: 2, green: 0, yellow: 1}

  attr_accessible :no_avatar_zone, :friends_zone, :unknown_zone, :subscriber_zone, :too_friendly_zone, :red, :yellow, :green
  belongs_to :voting


  def points_for_zone(zone = :all, state)
    return total_points(state) if zone == :all
    zone = zone.to_s
    fail ArgumentError.new("Zone #{zone} has not exist") if @attributes[zone].nil?
    @attributes[zone] * (cached_voters(state).count { |v| v.zone == ZONES[zone.to_sym] })
  end

  protected
  def cached_voters(state)
    get_voters_zones(state) if @cache.nil?
    @cache[state.id]
  end

  def for_each_voter_with_cache(state)
    get_voters_zones(state) if @cache.nil?
    @cache[state.id].each do |voter|
      yield voter
    end
  end

  def total_points(state)
    self.points_for_zone(:green, state) + self.points_for_zone(:yellow, state) + self.points_for_zone(:red, state)
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
