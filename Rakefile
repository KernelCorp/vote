#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Vote::Application.load_tasks

if ENV['RAILS_ENV'] == 'test'
  require 'rspec/core/rake_task'
  require 'coveralls/rake/task'
  RSpec::Core::RakeTask.new(:spec)
  task test_with_coveralls: [:spec]
end
