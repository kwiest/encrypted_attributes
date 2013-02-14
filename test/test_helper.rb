ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'

$:.unshift File.dirname(__FILE__)
require 'rails_app/config/environment'
require 'rails/test_help'
require 'pry'

# Run the migrations
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")

class MiniTest::Unit::TestCase
  def teardown
    User.reset_callbacks :validate
    User.reset_callbacks :save
  end
end
