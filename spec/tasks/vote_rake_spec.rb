require 'spec_helper'
require 'rake'

describe 'proff namespace rake task' do
  before :all do
    Rake.application.rake_require 'tasks/vote'
    Rake::Task.define_task(:environment)
  end

  describe 'vote:snapshot' do
    def run_task(task, args = nil)
      Rake::Task[task].reenable
      Rake.application.invoke_task "#{task}#{ args && "[#{args}]" }"
    end

    before :each do
      allow_any_instance_of(OtherVoting).to receive(:social_snapshot).and_return(true)
    end

    it 'invoke social_snapshot' do
      OtherVoting.first.update_attributes snapshot_frequency: :daily
      expect_any_instance_of(OtherVoting).to receive(:social_snapshot).and_return(true)
      run_task 'vote:snapshot', 'daily'
    end

    it 'old points to states' do
      voting = OtherVoting.first
      actions = Social::Action::Tw.where( voting_id: voting.id ).first

      actions.update_attributes like_points: 3, repost_points: 7

      voting.update_attributes status: :close

      @post = FactoryGirl.create :tw_post, voting: voting, participant: users(:middlebrow), url: 'https://twitter.com/Politru_project/status/451559020654886912'
      
      def points_to( points, likes, reposts )
        @post.update_attributes points: points
        run_task 'vote:states_for_finished'
        state = @post.states.last
        expect( state[:likes] ).to eq(likes)
        expect( state[:reposts] ).to eq(reposts)
      end

      points_to 42, 14, 0
      points_to 49,  0, 7
      points_to 16,  3, 1
      points_to 13,  4, 0
    end

  end
  
end
