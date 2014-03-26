require 'spec_helper'

describe Strategy do

  describe '#red_zone_points' do
    before :each do
      @state = FactoryGirl.create :state
      @strategy = FactoryGirl.create :strategy
    end

    it 'returns points for red zone' do
      assert_equal (@strategy.red_zone_points(@state)), 0.1
    end

    it 'returns points for yellow zone' do
      assert_equal (@strategy.yellow_zone_points(@state)), 0.5
    end

    it 'returns points for yellow zone' do
      assert_equal (@strategy.green_zone_points(@state)), 1
    end

    it 'returns total points' do
      assert_equal (@strategy.total_points(@state)), 1.6
    end

  end

end
