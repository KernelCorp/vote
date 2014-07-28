class Strategy < ActiveRecord::Base

  ZONES = { 0 => :green, 1 => :yellow, 2 => :red, 3 => :grey }

  attr_accessible :red, :yellow, :green, :grey, :criterions_attributes
  
  belongs_to :voting, class_name: 'OtherVoting'

  has_many :criterions, class_name: 'Strategy::Criterion::Base'
  accepts_nested_attributes_for :criterions, allow_destroy: true

  before_create do
    criterions.build zone: 0, type: 'Strategy::Criterion::Friend'
    criterions.build zone: 1, type: 'Strategy::Criterion::Follower'
    criterions.build zone: 2, type: 'Strategy::Criterion::Guest'
    criterions.build zone: 1, type: 'Strategy::Criterion::NoAvatar'
    criterions.build zone: 1, type: 'Strategy::Criterion::Friendly'
  end

  def likes_for_zone(zone = :all, state)
    info_for_zone zone, :liked, state
  end

  def reposts_for_zone(zone = :all, state)
    info_for_zone zone, :reposted, state
  end

  def info_for_zone(zone, info, state)
    if zone == :all
      ZONES.inject(0) { |sum, zone| sum += info_for_zone( zone[1], info, state )  }
    elsif zone == :grey
      grey * (state.send(info) - state.voters.where( info => true ).count)
    else
      count(zone, state) { |v| v.zone == zone.to_sym && v.send(info) == true }
    end
  end

  def cached_voters(state)
    get_voters_zones(state) if @cache.nil? || @cache[state.id].nil?
    @cache[state.id]
  end

  def criterions_matches_count(states)
    Rails.cache.fetch "criterions_matches_count_#{voting.id}", expires_in: (0.1).hour do
      counts = Hash.new 0
      criterions = self.criterions.all

      states.each do |state|
        post = state.post
        state.voters.all.each do |voter|
          criterions.each do |criterion|
            counts[criterion.id] += 1 if criterion.match voter, post
          end
        end
      end

      counts
    end
  end

  protected

  def count(zone, state)
    zone = zone.to_s
    fail ArgumentError.new("Zone #{zone} does not exist") if @attributes[zone].nil?
    @attributes[zone] * (cached_voters(state).count { |v| yield(v) })
  end

  def get_voters_zones(state)
    @cache ||= {}
    @cache[state.id] = state.voters.all

    post = state.post
    criterions = self.criterions.order('priority DESC, zone DESC').all

    @cache[state.id].each do |voter|
      if voter.zone
        voter.criterion = :custom
        next
      end

      voter.zone = 1
      voter.criterion = :default

      criterions.each do |criterion|
        if criterion.match voter, post
          voter.zone = criterion.zone
          voter.criterion = criterion
          break
        end
      end
    end
  end
end
