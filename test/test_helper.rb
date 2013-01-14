ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'

$:.unshift File.dirname(__FILE__)
require 'rails_app/config/environment'
require 'rails/test_help'

# Run the migrations
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")

# Mixin the factory helper
require File.expand_path("#{File.dirname(__FILE__)}/factory")
Test::Unit::TestCase.class_eval do
  include Factory
end
