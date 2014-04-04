require 'spec_helper'
require 'rake'

describe 'proff namespace rake task' do
  before :all do
    Rake.application.rake_require 'tasks/vote'
    Rake::Task.define_task(:environment)
  end

  describe 'vote:snapshot' do
    def run_task(task, args)
      Rake::Task[task].reenable
      Rake.application.invoke_task "#{task}[#{args}]"
    end

    before :each do
      allow_any_instance_of(OtherVoting).to receive(:social_snapshot).and_return(true)
    end

    it 'invoke social_snapshot' do
      OtherVoting.first.update_attributes snapshot_frequency: :daily
      expect_any_instance_of(OtherVoting).to receive(:social_snapshot).and_return(true)
      run_task 'vote:snapshot', 'daily'
    end

  end
  
end
