class Strategy < ActiveRecord::Base

  ZONES = {red: 2, green: 0, yellow: 1}

  attr_accessible :no_avatar_zone, :friend_zone, :follower_zone, :guest_zone, :too_friendly_zone, :red, :yellow, :green
  belongs_to :voting


  def likes_for_zone(zone = :all, state)
    return total_likes(state) if zone == :all
    n = count(zone, state) { |v| v.zone == ZONES[zone.to_sym] && v.liked }
    n += @attributes[zone.to_s] * (state.likes - state.voters.likers.count) if zone == :yellow
    return n
  end

  def reposts_for_zone(zone = :all, state)
    return total_reposts(state) if zone == :all
    n = count(zone, state) { |v| (v.zone == ZONES[zone.to_sym]) && v.reposted }
    n += @attributes[zone.to_s] * (state.reposts - state.voters.reposters.count) if zone == :yellow
    return n
  end

  protected

  def count(zone, state)
    zone = zone.to_s
    fail ArgumentError.new("Zone #{zone} does not exist") if @attributes[zone].nil?
    @attributes[zone] * (cached_voters(state).count { |v| yield(v) })
  end

  def cached_voters(state)
    get_voters_zones(state) if @cache.nil? || @cache[state.id].nil?
    @cache[state.id]
  end

  def for_each_voter_with_cache(state)
    get_voters_zones(state) if @cache.nil? || @cache[state.id].nil?
    @cache[state.id].each do |voter|
      yield voter
    end
  end

  def total_likes(state)
    self.likes_for_zone(:green, state) + self.likes_for_zone(:yellow, state) + self.likes_for_zone(:red, state)
  end

  def total_reposts(state)
    self.reposts_for_zone(:green, state) + self.reposts_for_zone(:yellow, state) + self.reposts_for_zone(:red, state)
  end

  def get_voters_zones(state)
    @cache ||= {}
    @cache[state.id] = state.voters.all
    @cache[state.id].each do |voter|
      zone = 1 #default zone
      zone = self.friend_zone   if voter.relationship == 'friend'
      zone = self.follower_zone if voter.relationship == 'follower'
      zone = self.guest_zone    if voter.relationship == 'guest'
      zone = [zone, self.no_avatar_zone].max if voter.has_avatar == false
      zone = [zone, self.too_friendly_zone].max if voter.too_friendly == true
      voter.zone = zone
    end
  end
end
