class Strategy < ActiveRecord::Base

  ZONES = {red: 2, yellow: 1, green: 0}

  attr_accessible :red, :yellow, :green, :criterions_attributes
  
  belongs_to :voting

  has_many :criterions, class_name: 'Strategy::Criterion'
  accepts_nested_attributes_for :criterions, allow_destroy: true

  before_create do
    criterions.build zone: 0, type: 'Strategy::Criterion::Friend'
    criterions.build zone: 1, type: 'Strategy::Criterion::Follower'
    criterions.build zone: 2, type: 'Strategy::Criterion::Guest'
    criterions.build zone: 1, type: 'Strategy::Criterion::NoAvatar'
    criterions.build zone: 1, type: 'Strategy::Criterion::Friendly'
  end

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

  def cached_voters(state)
    get_voters_zones(state) if @cache.nil? || @cache[state.id].nil?
    @cache[state.id]
  end

  protected

  def count(zone, state)
    zone = zone.to_s
    fail ArgumentError.new("Zone #{zone} does not exist") if @attributes[zone].nil?
    @attributes[zone] * (cached_voters(state).count { |v| yield(v) })
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

    criterions = self.criterions.order(priority: :desc, zone: :asc).all

    @cache[state.id].each do |voter|
      zone = 1

      criterions.each do |criterion|
        if criterion.match voter
          zone = criterion.zone
          voter.criterion = criterion.type
          puts criterion.type
          break
        end
      end

      voter.zone = zone
    end
  end
end
