require 'spec_helper'

describe Admin::OtherVotingsController do

  let(:voting) { votings :other_voting }
  let(:sample_post) {FactoryGirl.create :vk_post, url: 'http://vk.com/feed?w=wall-34580489_20875'}

  before :each do
    @admin = FactoryGirl.create :admin
    sign_in @admin
  end

  describe 'PUT update' do

    before :each do
      sample_post
      put :update, id: voting.id, other_voting: {status: 2}
    end

    it 'should execute complete!' do
      assert_equal voting.reload.status, :prizes
    end

    it 'should execute complete!' do
      assert !sample_post.reload.nil?
      assert !sample_post.participant.billinfo.nil?
    end
  end

end