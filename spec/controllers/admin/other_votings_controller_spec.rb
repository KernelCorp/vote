require 'spec_helper'

describe Admin::OtherVotingsController do

  let(:voting) { votings :other_voting }
  let(:sample_post) do 
    FactoryGirl.create :vk_action, voting: OtherVoting.first
    FactoryGirl.create :vk_post, url: 'http://vk.com/feed?w=wall-34580489_20875' 
  end

  before :each do
    @admin = FactoryGirl.create :admin
    sign_in @admin
  end

  describe 'PUT update' do

    before :each do
      sample_post
      FactoryGirl.create :strategy, voting_id: voting.id
      put :update, id: voting.id, other_voting: { status: 2 }
    end

    it 'should execute complete!' do
      expect( voting.reload.status ).to eq(:prizes)
      expect( sample_post.reload ).not_to be(nil)
      expect( sample_post.participant.billinfo ).not_to be(nil)
    end
  end

end
