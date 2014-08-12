require 'spec_helper'

describe Strategy do
  before :each do
    @state = FactoryGirl.create :state
    @strategy = FactoryGirl.create :strategy, voting_id: OtherVoting.first.id
  end

  it '#criterions_matches_count' do
    counts = @strategy.criterions_matches_count [@state]
    criterions = @strategy.criterions

    # expect(counts[criterions.where(type:'Strategy::Criterion::Friend').first.id]).to eq 1
    # expect(counts[criterions.where(type:'Strategy::Criterion::Follower').first.id]).to eq 1
    # expect(counts[criterions.where(type:'Strategy::Criterion::Guest').first.id]).to eq 1
    # expect(counts[criterions.where(type:'Strategy::Criterion::NoAvatar').first.id]).to eq 1
    expect(counts[criterions.where(type:'Strategy::Criterion::Friendly').first.id]).to eq 2
  end

  describe '#likes_for_zone' do
    it 'returns points for red zone' do
      expect(@strategy.likes_for_zone(:red, @state)).to eq(0.1)
    end

    it 'returns points for yellow zone' do
      expect(@strategy.likes_for_zone(:yellow, @state)).to eq(0.5)
    end

    it 'returns points for green  zone' do
      expect(@strategy.likes_for_zone(:green, @state)).to eq(1)
    end

    it 'returns total points' do
      expect(@strategy.likes_for_zone(@state)).to eq(2.6)
    end

    it 'can accept zone as string'  do
      expect(@strategy.likes_for_zone('green', @state)).to eq(1)
    end

    it 'fail if if it receives bad zone' do
      expect {@strategy.likes_for_zone(:black, @state)}.to raise_error(ArgumentError)
    end
  end

  describe '#reposts_for_zone' do
    it 'returns points for red zone' do
      expect(@strategy.reposts_for_zone(:red, @state)).to eq(0.0)
    end

    it 'returns points for yellow zone' do
      expect(@strategy.reposts_for_zone(:yellow, @state)).to eq(0.5)
    end

    it 'returns points for green  zone' do
      expect(@strategy.reposts_for_zone(:green, @state)).to eq(0)
    end

    it 'returns total points' do
      expect(@strategy.reposts_for_zone(@state)).to eq(1.5)
    end

    it 'can accept zone as string'  do
      expect(@strategy.reposts_for_zone('green', @state)).to eq(0)
    end

    it 'fail if if it receives bad zone' do
      expect {@strategy.reposts_for_zone(:black, @state)}.to raise_error(ArgumentError)
    end
  end

end
