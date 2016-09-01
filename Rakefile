# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

NolotiroOrg::Application.load_tasks

if %(test development).include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  Rake::TestTask.new(:test) do |t|
    t.libs << 'lib' << 'test'
    t.pattern = 'test/**/*_test.rb'
    t.warning = false
  end

  task :brakeman do
    system('brakeman --quiet')
  end

  # Hack to prevent tests from being run twice.
  # @todo Remove it, possibly when upgrading to Rails 5
  MiniTest.class_variable_set('@@installed_at_exit', true)

  task default: [:test, :rubocop, :brakeman]
end
