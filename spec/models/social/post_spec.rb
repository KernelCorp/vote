require 'spec_helper'

describe Social::Post do

  describe '#count_points' do

    before :each do
      @voting = FactoryGirl.create :voting
    end

    it 'count points' do
      expect(@voting.social_posts.first.count_points).to eq(4.2)
    end

  end

end
