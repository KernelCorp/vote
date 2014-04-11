class Strategy < ActiveRecord::Base

  ZONES = { 0 => :green, 1 => :yellow, 2 => :red }

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
    if zone == :all
      total_likes(state) + yellow * (state.likes - state.voters.likers.count)
    else
      count(zone, state) { |v| v.zone == zone.to_sym && v.liked }
    end
  end

  def reposts_for_zone(zone = :all, state)
    if zone == :all
      total_reposts(state) + yellow * (state.reposts - state.voters.reposters.count)
    else
      count(zone, state) { |v| v.zone == zone.to_sym && v.reposted }
    end
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

  def total_likes(state)
    likes_for_zone(:green, state) + likes_for_zone(:yellow, state) + likes_for_zone(:red, state)
  end

  def total_reposts(state)
    reposts_for_zone(:green, state) + reposts_for_zone(:yellow, state) + reposts_for_zone(:red, state)
  end

  def get_voters_zones(state)
    @cache ||= {}
    @cache[state.id] = state.voters.all

    criterions = self.criterions.order(priority: :desc, zone: :asc).all

    @cache[state.id].each do |voter|
      if voter.zone
        voter.criterion = 'custom'
        next
      end

      zone = 1
      criterion = 'default'

      criterions.each do |criterion|
        if criterion.match voter
          zone = criterion.zone
          criterion = criterion.type.scan(/\w+$/).first
          break
        end
      end

      voter.zone = zone
      voter.criterion = criterion
    end
  end
end
