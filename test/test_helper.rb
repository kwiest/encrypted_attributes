ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'

$:.unshift File.dirname(__FILE__)
require 'rails_app/config/environment'
require 'rails/test_help'

# Run the migrations
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")
