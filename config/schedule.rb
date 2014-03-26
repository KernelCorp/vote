# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, '/var/log/vote/whenever.log'

every :day, at: '4:00am' do
  command "echo 'Let\'s do some shooting!'"
  runner 'Voting.shoot_and_save'
end

every :day do
  rake 'vote:snapshot[1]'
end
every :hour do
  rake 'vote:snapshot[2]'
end
