require 'spec_helper'

describe Social::Post do

  describe 'count post points' do

    before :each do
      @voting = FactoryGirl.create :voting
    end

    it 'count_points' do
      expect @voting.post.count_points.to eq(3.2)
    end

  end

end
